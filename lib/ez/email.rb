# frozen_string_literal: true

require 'resolv'
require 'etc'
require 'socket'
require 'net/smtp'
require 'base64'
require 'mime/types'

# The EZ module serves as a namespace only.
module EZ
  # The Email class encapsulates certain SMTP attributes, which are then
  # used to send simple emails.
  class Email
    # The version of the ez-email library
    VERSION = '0.4.0'

    class << self
      # Writer method for the mail_host property.
      attr_writer :mail_host

      # Writer method for the mail_port property.
      attr_writer :mail_port

      # The name of the mail host to use when sending email. The default
      # is whatever the address of your system's 'mailhost' resolves to.
      # If that cannot be determined, your localhost is used.
      #
      def mail_host
        @mail_host ||= Resolv.getaddress('mailhost')
      rescue Resolv::ResolvError
        @mail_host ||= 'localhost'
      end

      # The port to use when sending email. The default is 25.
      #
      def mail_port
        @mail_port ||= 25
      end
    end

    # A single email address or an array of email addresses to whom
    # the email should be sent. Mandatory.
    attr_accessor :to

    # A single email address from whom the email is being delivered. The
    # default is your login + '@' + your host name, though it is recommended
    # that you specify it explicitly.
    attr_accessor :from

    # The subject of the email. Mandatory.
    attr_accessor :subject

    # The body of the email. Mandatory.
    attr_accessor :body

    # An array of file paths to attach to the email. Optional.
    attr_accessor :attachments

    # Creates a new EZ::Email object. As a general rule you won't use
    # this method, but should use EZ::Email.deliver instead.
    #
    def initialize(options = {})
      raise TypeError unless options.is_a?(Hash)
      options[:from] ||= "#{Etc.getlogin}@#{Socket.gethostname}"
      @attachments = []
      validate_options(options)
      @options = options
    end

    # Sends the email based on the options passed to the constructor.
    # As a general rule you won't use this method directly, but should
    # use EZ::Email.deliver instead.
    #
    def deliver
      host = EZ::Email.mail_host
      port = EZ::Email.mail_port

      to_list = to.is_a?(Array) ? to : [to]

      Net::SMTP.start(host, port, host) do |smtp|
        smtp.open_message_stream(from, to) do |stream|
          if attachments.empty?
            # Simple email without attachments
            stream.puts "From: #{from}"
            stream.puts "To: #{to_list.join(', ')}"
            stream.puts "Subject: #{subject}"
            stream.puts
            stream.puts body
          else
            # Email with attachments - use multipart MIME
            boundary = generate_boundary

            stream.puts "From: #{from}"
            stream.puts "To: #{to_list.join(', ')}"
            stream.puts "Subject: #{subject}"
            stream.puts "MIME-Version: 1.0"
            stream.puts "Content-Type: multipart/mixed; boundary=\"#{boundary}\""
            stream.puts

            # Text body part
            stream.puts "--#{boundary}"
            stream.puts "Content-Type: text/plain; charset=UTF-8"
            stream.puts "Content-Transfer-Encoding: 7bit"
            stream.puts
            stream.puts body
            stream.puts

            # Attachment parts
            attachments.each do |file_path|
              add_attachment(stream, file_path, boundary)
            end

            # End boundary
            stream.puts "--#{boundary}--"
          end
        end
      end
    end

    # Delivers a simple text email message using these options:
    #
    # * to
    # * from
    # * subject
    # * body
    # * attachments (optional)
    #
    # Examples:
    #
    #    # Send an email to a single user
    #    EZ::Email.deliver(
    #       :to      => 'some_user@hotmail.com',
    #       :from    => 'me@hotmail.com',
    #       :subject => 'Hi',
    #       :body    => 'How are you?'
    #    )
    #
    #    # Send an email to a multiple users
    #    EZ::Email.deliver(
    #       :to      => ['jon@hotmail.com', 'mary@hotmail.com'],
    #       :from    => 'me@hotmail.com',
    #       :subject => 'Hi',
    #       :body    => 'How are you?'
    #    )
    #
    #    # Send an email with attachments
    #    EZ::Email.deliver(
    #       :to          => 'someone@example.com',
    #       :from        => 'me@example.com',
    #       :subject     => 'Files attached',
    #       :body        => 'Please find the attached files.',
    #       :attachments => ['/path/to/file1.pdf', '/path/to/file2.txt']
    #    )
    #
    # This is a shortcut for EZ::Email.new + EZ::Email#deliver.
    #
    def self.deliver(options)
      new(options).deliver
    end

    private

    # Private method that both validates the hash options, and sets
    # the attribute values.
    #
    def validate_options(hash)
      valid = %w[to from subject body attachments]

      hash.each do |key, value|
        key = key.to_s.downcase
        raise ArgumentError unless valid.include?(key)

        if key == 'attachments'
          # Validate attachments
          attachments_value = value.is_a?(Array) ? value : [value]
          attachments_value.each do |file_path|
            raise ArgumentError, "Attachment file not found: #{file_path}" unless File.exist?(file_path)
            raise ArgumentError, "Attachment is not a file: #{file_path}" unless File.file?(file_path)
          end
          self.attachments = attachments_value
        else
          send("#{key}=", value)
        end
      end

      raise ArgumentError, 'Missing :to' if to.nil?
      raise ArgumentError, 'Missing :subject' if subject.nil?
      raise ArgumentError, 'Missing :body' if body.nil?
    end

    # Generate a unique boundary for multipart MIME messages
    def generate_boundary
      "----=_NextPart_#{Time.now.to_i}_#{rand(1000000)}"
    end

    # Add an attachment to the email stream
    def add_attachment(stream, file_path, boundary)
      filename = File.basename(file_path)

      # Determine MIME type
      mime_type = MIME::Types.type_for(file_path).first
      content_type = mime_type ? mime_type.content_type : 'application/octet-stream'

      stream.puts "--#{boundary}"
      stream.puts "Content-Type: #{content_type}; name=\"#{filename}\""
      stream.puts "Content-Transfer-Encoding: base64"
      stream.puts "Content-Disposition: attachment; filename=\"#{filename}\""
      stream.puts

      # Read file and encode as base64
      file_content = File.read(file_path)
      encoded_content = Base64.encode64(file_content)
      stream.puts encoded_content
      stream.puts
    end
  end
end

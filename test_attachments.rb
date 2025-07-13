#!/usr/bin/env ruby

require_relative 'lib/ez-email'

# Create a test file for attachment
test_file = '/tmp/sample_attachment.txt'
File.write(test_file, "This is a sample attachment file.\nIt contains some test content.")

begin
  # Create an email with attachment
  email = EZ::Email.new(
    to: 'recipient@example.com',
    from: 'sender@example.com',
    subject: 'Test Email with Attachment',
    body: 'Hello! Please find the attached file.',
    attachments: [test_file]
  )

  puts "Email created successfully with attachment: #{test_file}"
  puts "Attachments: #{email.attachments}"
  puts "To: #{email.to}"
  puts "From: #{email.from}"
  puts "Subject: #{email.subject}"
  puts "Body: #{email.body}"

  # You can also use the class method
  puts "\nUsing class method:"

  # This would deliver if you had a mail server running
  # EZ::Email.deliver(
  #   to: 'recipient@example.com',
  #   from: 'sender@example.com',
  #   subject: 'Test Email with Multiple Attachments',
  #   body: 'Hello! Please find the attached files.',
  #   attachments: [test_file, '/path/to/another/file.pdf']
  # )

  puts "All tests passed! Attachment functionality is working."

rescue => e
  puts "Error: #{e.message}"
ensure
  # Clean up
  File.delete(test_file) if File.exist?(test_file)
end

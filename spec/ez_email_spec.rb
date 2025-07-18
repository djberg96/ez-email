########################################################################
# ez_email_spec.rb
#
# Specs for the EZ::Email library. These specs assume that you are
# running the mailhog docker container on port 1025.
#
# Install docker and run "docker compose run mailhog" first.
########################################################################
require 'rspec'
require 'ez/email'
require 'socket'
require 'etc'

RSpec.describe EZ::Email do
  let(:host){ Socket.gethostname }
  let(:login){ Etc.getlogin }
  let(:port){ 1025 }

  before do
    @to   = 'foo@some_mail_service.com'
    @from = 'bar@some_mail_service.com'
    @subj = 'This is a test'
    @body = 'How are you?'

    @opts = {:to => @to, :from => @from, :subject => @subj, :body => @body }
    @email = EZ::Email.new(@opts)
  end

  example "version is set to expected value" do
    expect(EZ::Email::VERSION).to eq('0.4.0')
    expect(EZ::Email::VERSION).to be_frozen
  end

  example "to getter method basic functionality" do
    expect(@email).to respond_to(:to)
    expect{ @email.to }.not_to raise_error
    expect(@email.to).not_to be_nil
  end

  example "to getter method returns expected value" do
    expect(@email.to).to eq(@to)
  end

  example "to setter method basic functionality" do
    expect(@email).to respond_to(:to=)
    expect{ @email.to = 'bogus@some_bogus.com' }.not_to raise_error
  end

  example "to setter actually sets value" do
    @email.to = 'bogus@some_bogus.com'
    expect('bogus@some_bogus.com').to eq(@email.to)
  end

  example "from getter basic functionality" do
    expect(@email).to respond_to(:from)
    expect{ @email.from }.not_to raise_error
    expect(@email.from).not_to be_nil
  end

  example "from setter basic functionality" do
    expect(@email).to respond_to(:from=)
    expect{ @email.from = 'bogus@some_bogus.com' }.not_to raise_error
  end

  example "from method returns expected value" do
    expect(@email.from).to eq(@from)
  end

  example "from defaults to username@host if not set in constructor" do
    @email = EZ::Email.new(:to => 'x', :subject => 'x', :body => 'x')
    expected = login << '@' << host
    expect(@email.from).to eq(expected)
  end

  example "subject getter basic functionality" do
    expect(@email).to respond_to(:subject)
    expect{ @email.subject }.not_to raise_error
    expect(@email.subject).not_to be_nil
  end

  example "subject setter basic functionality" do
    expect(@email).to respond_to(:subject=)
    expect{ @email.subject = 'bogus@bogus.com' }.not_to raise_error
  end

  example "subject method returns expected value" do
    expect(@email.subject).to eq(@subj)
  end

  example "body getter basic functionality" do
    expect(@email).to respond_to(:body)
    expect{ @email.body }.not_to raise_error
    expect(@email.body).not_to be_nil
  end

  example "body setter basic functionality" do
    expect(@email).to respond_to(:body=)
    expect{ @email.body = "Test" }.not_to raise_error
  end

  example "body method returns the expected value" do
    expect(@email.body).to eq(@body)
  end

  example "mail_host getter basic functionality" do
    expect(EZ::Email).to respond_to(:mail_host)
    expect{ EZ::Email.mail_host }.not_to raise_error
    expect(EZ::Email.mail_host).not_to be_nil
  end

  example "mail_host setter basic functionality" do
    expect(EZ::Email).to respond_to(:mail_host=)
    expect{ EZ::Email.mail_host = 'Test' }.not_to raise_error
    expect(EZ::Email.mail_host).to eq('Test')
  end

  example "mail_port singleton getter basic functionality" do
    expect(EZ::Email).to respond_to(:mail_port)
  end

  example "mail_port method returns the expected default value" do
    expect(EZ::Email.mail_port).to eq(25)
  end

  example "mail_port singleton setter basic functionality" do
    expect(EZ::Email).to respond_to(:mail_port=)
    expect{ EZ::Email.mail_port = port }.not_to raise_error
    expect(EZ::Email.mail_port).to eq(1025)
  end

  example "deliver singleton method basic functionality" do
    expect(EZ::Email).to respond_to(:deliver)
  end

  example "deliver singleton method works without error" do
    EZ::Email.mail_host = 'localhost'
    EZ::Email.mail_port = port
    expect{ EZ::Email.deliver(@opts) }.not_to raise_error
  end

  example "passing an invalid option to the constructor raises an error" do
    expect{ EZ::Email.send(:new, {:bogus => 77}) }.to raise_error(ArgumentError)
  end

  example "attachments getter basic functionality" do
    expect(@email).to respond_to(:attachments)
    expect{ @email.attachments }.not_to raise_error
  end

  example "attachments setter basic functionality" do
    expect(@email).to respond_to(:attachments=)
    expect{ @email.attachments = [] }.not_to raise_error
  end

  example "attachments method returns an array" do
    expect(@email.attachments).to be_an(Array)
  end

  example "attachments defaults to empty array" do
    expect(@email.attachments).to be_empty
  end

  example "can set attachments via constructor" do
    # Create a test file
    test_file = '/tmp/test_attachment.txt'
    File.write(test_file, 'test content')

    begin
      opts_with_attachments = @opts.merge(attachments: [test_file])
      email = EZ::Email.new(opts_with_attachments)
      expect(email.attachments).to eq([test_file])
    ensure
      File.delete(test_file) if File.exist?(test_file)
    end
  end

  example "raises error for non-existent attachment file" do
    opts_with_bad_attachment = @opts.merge(attachments: ['/non/existent/file.txt'])
    expect{ EZ::Email.new(opts_with_bad_attachment) }.to raise_error(ArgumentError, /Attachment file not found/)
  end

  example "can deliver email with attachments" do
    # Create a test file
    test_file = '/tmp/test_attachment.txt'
    File.write(test_file, 'test content for attachment')

    begin
      EZ::Email.mail_host = 'localhost'
      EZ::Email.mail_port = port

      opts_with_attachments = @opts.merge(attachments: [test_file])
      expect{ EZ::Email.deliver(opts_with_attachments) }.not_to raise_error
    ensure
      File.delete(test_file) if File.exist?(test_file)
    end
  end
end

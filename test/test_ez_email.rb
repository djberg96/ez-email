########################################################################
# test_ez_email.rb
#
# Test suite for the EZ::Email library.
########################################################################
require 'test-unit'
require 'ez/email'
require 'socket'
require 'etc'

class TC_EZ_Email < Test::Unit::TestCase
  def self.startup
    @@host  = Socket.gethostname
    @@login = Etc.getlogin
  end

  def setup
    @to   = 'foo@some_mail_service.com'
    @from = 'bar@some_mail_service.com'
    @subj = 'This is a test'
    @body = 'How are you?'

    @opts = {:to => @to, :from => @from, :subject => @subj, :body => @body }
    @email = EZ::Email.new(@opts)
  end

  test "version is set to expected value" do
    assert_equal('0.1.3', EZ::Email::VERSION)
  end

  test "to getter method basic functionality" do
    assert_respond_to(@email, :to)
    assert_nothing_raised{ @email.to }
    assert_not_nil(@email.to)
  end

  test "to getter method returns expected value" do
    assert_equal(@to, @email.to)
  end

  test "to setter method basic functionality" do
    assert_respond_to(@email, :to=)
    assert_nothing_raised{ @email.to = 'bogus@some_bogus.com' }
  end

  test "to setter actually sets value" do
    @email.to = 'bogus@some_bogus.com'
    assert_equal(@email.to, 'bogus@some_bogus.com')
  end

  test "from getter basic functionality" do
    assert_respond_to(@email, :from)
    assert_nothing_raised{ @email.from }
    assert_not_nil(@email.from)
  end

  test "from setter basic functionality" do
    assert_respond_to(@email, :from=)
    assert_nothing_raised{ @email.from = 'bogus@some_bogus.com' }
  end

  test "from method returns expected value" do
    assert_equal(@from, @email.from)
  end

  test "from defaults to username@host if not set in constructor" do
    @email = EZ::Email.new(:to => 'x', :subject => 'x', :body => 'x')
    expected = @@login << '@' << @@host
    assert_equal(expected, @email.from)
  end

  test "subject getter basic functionality" do
    assert_respond_to(@email, :subject)
    assert_nothing_raised{ @email.subject }
    assert_not_nil(@email.subject)
  end

  test "subject setter basic functionality" do
    assert_respond_to(@email, :subject=)
    assert_nothing_raised{ @email.subject = 'bogus@bogus.com' }
  end

  test "subject method returns expected value" do
    assert_equal(@subj, @email.subject)
  end

  test "body getter basic functionality" do
    assert_respond_to(@email, :body)
    assert_nothing_raised{ @email.body }
    assert_not_nil(@email.body)
  end

  test "body setter basic functionality" do
    assert_respond_to(@email, :body=)
    assert_nothing_raised{ @email.body = "Test" }
  end

  test "body method returns the expected value" do
    assert_equal(@body, @email.body)
  end

  test "mail_host getter basic functionality" do
    assert_respond_to(EZ::Email, :mail_host)
    assert_nothing_raised{ EZ::Email.mail_host }
    assert_not_nil(EZ::Email.mail_host)
  end

  test "mail_host setter basic functionality" do
    assert_respond_to(EZ::Email, :mail_host=)
    assert_nothing_raised{ EZ::Email.mail_host = "Test" }
  end

  test "mail_port singleton getter basic functionality" do
    assert_respond_to(EZ::Email, :mail_port)
  end

  test "mail_port singleton setter basic functionality" do
    assert_respond_to(EZ::Email, :mail_port=)
  end

  test "mail_port method returns the expected value" do
    assert_equal(25, EZ::Email.mail_port)
  end

  test "deliver singleton method basic functionality" do
    assert_respond_to(EZ::Email, :deliver)
  end

  test "passing an invalid option to the constructor raises an error" do
    assert_raise(ArgumentError){ EZ::Email.send(:new, {:bogus => 77}) }
  end

  def teardown
    @to    = nil
    @from  = nil
    @subj  = nil
    @body  = nil
    @opts  = nil
    @email = nil
  end

  def self.shutdown
    @@host  = nil
    @@login = nil
  end
end

########################################################################
# test_ez_email.rb
#
# Test suite for the EZ::Email library.
########################################################################
require 'test/unit'
require 'ez/email'

class TC_EZ_Email < Test::Unit::TestCase
   def setup
      @to   = 'foo@some_mail_service.com'
      @from = 'bar@some_mail_service.com'
      @subj = 'This is a test'
      @body = 'How are you?'

      @opts = {:to => @to, :from => @from, :subject => @subj, :body => @body }
      @email = EZ::Email.new(@opts)
   end
   
   def test_version
      assert_equal('0.1.1', EZ::Email::VERSION)      
   end

   def test_to
      assert_respond_to(@email, :to)
      assert_respond_to(@email, :to=)
      assert_equal(@to, @email.to)
   end

   def test_from
      assert_respond_to(@email, :from)
      assert_respond_to(@email, :from=)
      assert_equal(@from, @email.from)
   end

   def test_subject
      assert_respond_to(@email, :subject)
      assert_respond_to(@email, :subject=)
      assert_equal(@subj, @email.subject)
   end

   def test_body
      assert_respond_to(@email, :body)
      assert_respond_to(@email, :body=)
      assert_equal(@body, @email.body)
   end

   def test_mail_host
      assert_respond_to(EZ::Email, :mail_host)
      assert_respond_to(EZ::Email, :mail_host=)
      assert_kind_of(String, EZ::Email.mail_host)
   end

   def test_mail_port
      assert_respond_to(EZ::Email, :mail_port)
      assert_respond_to(EZ::Email, :mail_port=)
      assert_equal(25, EZ::Email.mail_port)
   end

   def test_deliver
      assert_respond_to(EZ::Email, :deliver)
   end

   def test_invalid_option_raises_error
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
end

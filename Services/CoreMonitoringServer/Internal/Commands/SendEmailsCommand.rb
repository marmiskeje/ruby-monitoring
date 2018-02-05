class SendEmailsCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end
  def on_execute
    if @context.emails.size > 0
      gmail = Gmail.connect("ruby.monitoring.miskeje", "Ruby.S3cr3t.Pass.Q4A")
      begin
        @context.emails.each do |e|
          gmail.deliver do
            to e.recipients.to_a.join(",")
            subject e.subject
            html_part do
              content_type 'text/html; charset=UTF-8'
              body e.body
            end
          end
        end
      ensure
        gmail.logout
      end
    end
  end
end
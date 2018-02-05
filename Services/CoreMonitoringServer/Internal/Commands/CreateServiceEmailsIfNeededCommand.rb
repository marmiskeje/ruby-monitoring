class CreateServiceEmailIfNeededCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end
  def on_execute
    @context.message.changed_services.each do |s|
      service_conf = @context.server_configuration.watched_services[s.name]
      if !service_conf.nil?
        profile = service_conf.state_profiles[s.state]
        if !profile.nil? && profile.action = MonitoringAction::EmailAction
          email = EmailDefinition.new
          email.subject = "[%s] Server: %s Service: %s" % [profile.severity.upcase, @context.message.server_name, + s.name]
          email.body = "<p>Server: <strong>%s</strong></p><p><strong>%s</strong>: State of service <strong>%s</strong> was changed to <strong>%s</strong>.</p>" % [@context.message.server_name, @context.message.event_date, s.name, s.state]
          @context.emails.add(email)
        end
      end
    end
  end
end
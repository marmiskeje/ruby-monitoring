class CreateHddEmailsIfNeededCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end
  def on_execute
    @context.message.changed_drives.each do |d|
      hdd_conf = @context.server_configuration.watched_drives[d.path]
      if !hdd_conf.nil?
        free_space_percentage = 0
        free_space_percentage = ((d.free_bytes / d.total_bytes.to_f) * 100.0) unless d.total_bytes == 0
        profile = nil
        hdd_conf.free_space_percentage_profiles.each do |k, v|
          if free_space_percentage <= k
            profile = v
            break
          end
        end
        if !profile.nil? && profile.action = MonitoringAction::EmailAction
          email = EmailDefinition.new
          email.subject = "[%s] Server: %s HDD: %s" % [profile.severity.upcase, @context.message.server_name, + d.path]
          email.body = "<p>Server: <strong>%s</strong></p><p><strong>%s</strong>: HDD´s <strong>%s</strong> free space was changed to <strong>%s %%</strong>.</p>" % [@context.message.server_name, @context.message.event_date, d.path, free_space_percentage.round(0)]
          @context.emails.add(email)
        end
      end
    end
  end
end
require 'slack-notifier'

class Notifier
  def self.get_notifier
    notifier = Slack::Notifier.new(AppSettings.slack_web_hook_url,
                                    channel: AppSettings.slack_job_channel,
                                    username: 'Tilde ~')
    return notifier
  end

  def self.post_job_to_slack(job_id)
    @notifier = Notifier.get_notifier
    job = Job.find(job_id).decorate

    message = {
        "attachments": [
            {
                "fallback": ":briefcase: #{job.title}",
                "text": ":briefcase: #{job.title}",
                "fields": [
                    {
                        "title": "Company",
                        "value": job.company_name,
                        "short": true
                    },
                    {
                        "title": "Posted by",
                        "value": job.user.name,
                        "short": true
                    },
                    {
                        "title": "Country",
                        "value": job.location_name,
                        "short": true
                    },
                    {
                        "title": "Expected salary",
                        "value": job.salary_to_s,
                        "short": true
                    },
                    {
                        "title": "Email to apply",
                        "value": job.apply_email,
                        "short": true
                    },
                    {
                        "title": "For more details, check out the following link:",
                        "value": "#{AppSettings.application_host}/jobs/#{job.custom_identifier}?md=slack",
                        "short": false
                    }
                ],
                "color": "#F35A00"
            }
        ]
    }
    @notifier.ping(message, channel: AppSettings.slack_job_channel)
  end
end

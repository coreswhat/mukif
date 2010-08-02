
Mukif.helpers do
  
  # controller
  
    def list_cron_jobs
      cron_jobs = %x{crontab -l}
      cron_jobs = nil if cron_jobs.blank? || cron_jobs.gsub("\n", '').strip.blank?
      cron_jobs
    end
end
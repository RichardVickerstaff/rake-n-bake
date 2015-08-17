begin
  require 'metric_fu'

rescue LoadError

  namespace :metrics do
    %w[all cane churn flay flog hotspots only reek roodi saikuro stats].map(&:to_sym).each do |t|
      desc 'metric_fu rake tasks are not available (gem not installed)'
      task t do
        RakeNBake::AssistantBaker.log_missing_gem 'metric_fu'
        abort
      end
    end
  end

end

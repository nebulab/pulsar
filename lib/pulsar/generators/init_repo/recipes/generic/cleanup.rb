if logger.level == Capistrano::Logger::IMPORTANT
  arrow = "→".yellow.bold
  ok = "✓".green

  before "deploy:update_code" do
    SpinningCursor.start do
      banner "#{arrow} Updating Code"
      message "#{arrow} Updating Code #{ok}"
    end
  end

  before "bundle:install" do
    SpinningCursor.start do
      banner "#{arrow} Installing Gems"
      message "#{arrow} Installing Gems #{ok}"
    end
  end

  before "deploy:assets:symlink" do
    SpinningCursor.start do
      banner "#{arrow} Symlinking Assets"
      message "#{arrow} Symlinking Assets #{ok}"
    end
  end

  before "deploy:assets:precompile" do
    SpinningCursor.start do
      banner "#{arrow} Compiling Assets"
      message "#{arrow} Compiling Assets #{ok}"
    end
  end

  before "deploy:create_symlink" do
    SpinningCursor.start do
      banner "#{arrow} Symlinking Application"
      message "#{arrow} Symlinking Application #{ok}"
    end
  end

  before "deploy:restart" do
    SpinningCursor.start do
      banner "#{arrow} Restarting Webserver"
      message "#{arrow} Restarting Webserver #{ok}"
    end
  end

  after "deploy" do
    SpinningCursor.stop
  end
end

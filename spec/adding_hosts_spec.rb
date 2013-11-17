require "capybara/rspec"

RSpec.configure do |config|

  config.before :all do
    FileUtils.cp('spec/stubs/hostspecs/Hostspec', './Hostspec') if File.exist?('spec/stubs/hostspecs/Hostspec')
  end

  config.before :each do
    File.delete('spec/stubs/hosts/hosts.tmp') if File.exist?('spec/stubs/hosts/hosts.tmp')
    FileUtils.cp('spec/stubs/hosts/hosts.template', 'spec/stubs/hosts/hosts.tmp') if File.exist?('spec/stubs/hosts/hosts.template')
  end

  config.after :all do
    File.delete('./Hostspec') if File.exist?('./Hostspec')
    File.delete('spec/stubs/hosts/hosts.tmp') if File.exist?('spec/stubs/hosts/hosts.tmp')
  end

end

feature "adding hosts" do

  scenario "adding a host" do
    stdout = %x{ ./bin/marina.rb spec/stubs/hosts/hosts.tmp spec/stubs/hostspecs/Hostspec }
    stdout.should eq "\nAdding hosts to hosts file:\n\t- win.com written to the hosts file\n"

    File.open('spec/stubs/hosts/hosts.tmp') do |temporary_hosts_file|
      File.open('spec/stubs/hosts/hosts.reference.single') do |reference_hosts_file|
        (temporary_hosts_file.read).should eq (reference_hosts_file.read)
      end
    end

    $?.exitstatus.should eq 0
  end

  scenario "adding a host with no Hostspec argument" do
    %x{ ./bin/marina.rb spec/stubs/hosts/hosts.tmp}

    File.open('spec/stubs/hosts/hosts.tmp') do |temporary_hosts_file|
      File.open('spec/stubs/hosts/hosts.reference.single') do |reference_hosts_file|
        (temporary_hosts_file.read).should eq (reference_hosts_file.read)
      end
    end

    $?.exitstatus.should eq 0
  end


  scenario "adding multiple hosts" do
    %x{ ./bin/marina.rb spec/stubs/hosts/hosts.tmp spec/stubs/hostspecs/multiple_hostspec }

    File.open('spec/stubs/hosts/hosts.tmp') do |temporary_hosts_file|
      File.open('spec/stubs/hosts/hosts.reference.multiple') do |reference_hosts_file|
        (temporary_hosts_file.read).should eq (reference_hosts_file.read)
      end
    end

    $?.exitstatus.should eq 0
  end

  scenario "specified, but non-existent hosts file" do
    stdout = %x{ ./bin/marina.rb spec/stubs/hosts/hosts_file_that_does_not_exist spec/stubs/hostspecs/Hostspec }
    stdout.should eq "marina: spec/stubs/hosts/hosts_file_that_does_not_exist: No such file\n"
    $?.exitstatus.should eq 66
  end

  scenario "specified, but non-existent Hostspec file" do
    stdout = %x{ ./bin/marina.rb spec/stubs/hosts/hosts.tmp spec/stubs/hostspecs/hostspec_file_that_does_not_exist }
    stdout.should eq "marina: spec/stubs/hostspecs/hostspec_file_that_does_not_exist: No such file\n"
    $?.exitstatus.should eq 66
  end

  scenario "specified, but non-existent Hostspec file & host file" do
    stdout = %x{ ./bin/marina.rb spec/stubs/hosts/hosts_file_that_does_not_exist  spec/stubs/hostspecs/hostspec_file_that_does_not_exist }
    stdout.should eq "marina: spec/stubs/hostspecs/hostspec_file_that_does_not_exist: No such file\n"
    $?.exitstatus.should eq 66
  end

  scenario "accessing /etc/hosts" do
    stdout = %x{ ./bin/marina.rb }
    stdout.should eq "\nAdding hosts to hosts file:\n\tmarina: /etc/hosts: Permission denied\n"
    $?.exitstatus.should eq 66
  end

end

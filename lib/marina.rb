require 'marina/version'

class Marina

  attr_accessor :specified_hosts, :host_entries, :hostspec_file_path, :hosts_file_path

  def initialize hosts_file_path = '/etc/hosts', hostspec_file_path = 'Hostspec'
    @hosts_file_path = hosts_file_path
    @hostspec_file_path = hostspec_file_path
    @specified_hosts = []
  end

  def list
    answer = clean_hosts || 'Host file does not exist'
    puts answer
  end

  def host host
    @specified_hosts << host
  end

  def add_to_hostfile
    begin
      puts "\nAdding hosts to hosts file:" if File.exists?(@hosts_file_path)
      specified_hosts.each do |host_spec|
        if host_entries.include? "127.0.0.1 #{host_spec}\n"
          puts "\t-\s#{host_spec} is already in the hosts file"
          next
        end
        hosts.write("127.0.0.1 #{host_spec}\n")
        puts "\t-\s#{host_spec} written to the hosts file"
      end
    rescue IOError
    rescue Errno::ENOENT
      puts "marina: #{@hosts_file_path}: No such file"
      exit(66)
    rescue Errno::EACCES
      puts "\tmarina: #{@hosts_file_path}: Permission denied"
      exit(66)
    end
  end

  private

  def host_entries bust = nil
    @host_entries = nil if bust
    @host_entries ||= hosts.entries
  end

  def hosts
    if File.exists?(@hosts_file_path)
      File.open(@hosts_file_path, 'a+')
    else
      raise Errno::ENOENT
    end
  end

  def clean_hosts
    return nil unless File.exists?(@hosts_file_path)

    File.open(@hosts_file_path) do |hosts_file|
      return chaff_free hosts_file
    end
  end

  def chaff_free(hosts_file)
    hosts_file.each_line.reject do |line|
      is_a_comment?(line) or not is_localhost?(line)
    end
  end

  def is_a_comment?(line)
    line =~ /\A\#/
  end

  def is_localhost?(line)
    line =~ /\A127\.0\.0\.1/
  end

end

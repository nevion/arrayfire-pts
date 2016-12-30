output = `./bin/benchmark_cpu -l|grep -v JIT|awk ' NR > 10 { print $2 } NR <= 10 { next }'`
#puts(output)
compute_device = ENV['COMPUTE_DEVICE'] || '0'
puts("compute device #{compute_device}")
output.lines.map(&:chomp).each do |benchmark|
    cmd = "timeout -s SIGKILL 15 ./bin/benchmark_opencl -d #{compute_device} -b #{benchmark} --use-max-problemspace"
    #cmd = "/bin/benchmark_opencl -d #{compute_device} -b #{benchmark}"
    puts(cmd)
    output = `#{cmd}`
    ouput= output.gsub(/\e\[([;\d]+)?m/, '') #scrub colorings
    if $?.exitstatus != 0
        puts "#{benchmark} failed to run in given timeperiod, adding to failures"
        open('failures.txt', 'a') { |f|
              f.puts "#{benchmark}"
              f.puts output
        }
    end
end

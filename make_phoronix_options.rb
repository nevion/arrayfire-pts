output = `./bin/benchmark_cpu -l|grep -v JIT|awk ' NR > 10 { print $2 } NR <= 10 { next }'`
#puts(output)
puts "<Menu>"

output.lines.map(&:chomp).each do |benchmark|
    t="""
    <Entry>
      <Name>#{benchmark}</Name>
      <Value>#{benchmark}</Value>
    </Entry>
"""
    puts(t[1..-1])
end
puts "</Menu>"

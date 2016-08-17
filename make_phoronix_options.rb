output = `./bin/benchmark_cpu -l|grep -v JIT|awk ' NR > 10 { print $2 } NR <= 10 { next }'`
#puts(output)
output.lines.map(&:chomp).each do |benchmark|
    t="""
<Menu>
<Entry>
  <Name>#{benchmark}</Name>
  <Value>#{benchmark}</Value>
</Entry>
</Menu>
"""
    puts(t.strip)
end

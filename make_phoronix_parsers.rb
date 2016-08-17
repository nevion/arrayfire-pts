output = `./bin/benchmark_cpu -l|grep -v JIT|awk ' NR > 10 { print $2 } NR <= 10 { next }'`
#puts(output)
output.lines.map(&:chomp).each do |benchmark|

    t = """
<ResultsParser>
    <OutputTemplate>Sort            | #{benchmark} |        1 |              10 |              10 |     1.00000 |      #_RESULT_# |          0.0 |</OutputTemplate>
    <MatchToTestArguments>#{benchmark}</MatchToTestArguments>
</ResultsParser>
   """
    puts(t.strip)
end

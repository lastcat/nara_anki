require 'open-uri'
require 'pdf-reader'
require 'pry'

files = [
    'build.txt',
    'bungaku.txt',
    'iseki.txt',
    'kankou.txt',
    'kougei.txt',
    'maturi.txt',
    'rekisi.txt',
    'shizen.txt',
    'tokushu.txt'
]

answers = {}
problems = {}

#=begin
files.each do |i|
    File.open(i, mode="rt") do |f|
        lines = f.readlines
        lines.each_with_index do |l, idx|
            if (idx == 0 || idx == 1 || idx == 2 || idx == 3)
                next
            end
            answer = l.split("\t")[1]
            problems[l.split("\t")[0]] = {
                'count' => 0,
                'related_words' => [answer],
                'marked' => false,
                'answer' => answer
            }
            if (answer == nil) then
                puts l
            end
            if (answers.keys.include?(answer)) then
                answers[answer] += 1
            else
                answers[answer] = 1
            end
        end
    end
end


#p answers.sort_by {|key, val| -val }
answers.keys.each do |a|
    problems.keys.each do |pro|
        if(pro.include?(a)) then
            problems[pro]['count'] += 1
            problems[pro]['related_words'].push(a)
        end
    end
end
#p problems.sort_by {|key, val| -val['count'] }
related_problems = []


problems.keys.each do |k|
    related_set = []
    unless problems[k]['marked'] then
        puts k+" A:" +problems[k]['answer']
        puts "の類題"
        related_set.push(k+" A: " +problems[k]['answer'])
        problems[k]['marked'] = true
        problems.keys.each do |_k|
            if  problems[_k]['marked'] == false && (problems[k]['related_words'] & problems[_k]['related_words']).length > 0
                # related_set.push("共通ワード: " + (problems[k]['related_words'] & problems[_k]['related_words'])[0])
                related_set.push(_k+" A: " +problems[_k]['answer'])
                problems[_k]['marked'] = true
                puts _k+" A:" +problems[_k]['answer']
                puts "共通ワード"
                p problems[k]['related_words'] & problems[_k]['related_words']
            end
        end
    end
    puts "\n"
    if (related_set.length > 0) then
        related_problems.push(related_set)
    end
end

#=begin
related_problems.sort_by{|a| a.length}.reverse.each do |set|
    p set
    puts "\n"
end
    #=end
=begin
array = [1,2,3,4]
array.each_with_index do |e,i|
    array.each do |e|
        p array
        array[i] = 100
    end
end
=end
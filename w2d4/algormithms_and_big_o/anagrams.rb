require 'benchmark'

ALPHABET = ('a'..'z').to_a

def first_anagram?(string1, string2)
  anagrams = string1.chars.permutation #n!
  anagrams = anagrams.map {|anagram| anagram.join } #n * n!
  anagrams.include?(string2)  #n!

end

def second_anagram?(string1, string2)  #space complexity O(n)
  string1 = string1.chars #n
  string2 = string2.chars #m

  string1.each_with_index do |letter1, idx1| #n( #m )
    string2.each_with_index do |letter2, idx2| #m
      if letter1 == letter2
        string1[idx1] = nil
        string2[idx2] = nil
      end
    end
  end

  string1.delete(nil)
  string2.delete(nil)
  string1 == string2
end # O(n^2)


def third_anagram?(string1, string2) #space complexity is O(n)
  string1.chars.sort == string2.chars.sort #default sort  = 2(n log n) + 2n + n  == O(n log n)
end

def fourth_anagram?(string1, string2) #space complexity is O(n), time O(n)
  hash1 = Hash.new(0)
  hash2 = Hash.new(0)   #if key is nonexist, then value is zero
  string1.each_char do |letter|
    hash1[letter] += 1
  end
  string2.each_char do |letter|
    hash2[letter] += 1
  end
  hash1 == hash2
end

def fifth_anagram?(string1, string2) #space complexity is O(n), time O(n)
  hash = Hash.new(0)
  string1.each_char do |letter|
    hash[letter] += 1
  end
  string2.each_char do |letter|
    hash[letter] -= 1
  end

  hash.values.all? { |value| value == 0 }
end

[10, 1000, 100_000, 10_000_000, 1_000_000_000].each do |size|

  string1 = ''
  size.times { string1 << ALPHABET.sample }
  string2 = string1.chars.shuffle.join

  Benchmark.bm(3) do |x|
    puts "testing #{size}..."
    # x.report("first_anagram") { first_anagram?(string1, string2)  }

    # x.report("second_anagram")  { second_anagram?(string1, string2) }

    x.report("third_anagram") { third_anagram?(string1, string2)  }

    x.report("fourth_anagram") { fourth_anagram?(string1, string2)  }

    x.report("fifth_anagram") { fifth_anagram?(string1, string2)  }
  end
end

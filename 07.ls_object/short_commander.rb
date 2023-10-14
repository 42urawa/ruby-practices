# frozen_string_literal: true

class ShortCommander
  def initialize(file_paths)
    @file_paths = file_paths
  end

  def show
    puts segments
  end

  def segments
    names = @file_paths.map { |file_path| File.basename(file_path) }
    max_digit_of_names = names.map(&:length).max
    names_left_aligned = names.map { |name| name.ljust(max_digit_of_names) }
    names_transposed = transpose_names(names_left_aligned)
    names_transposed.map { |name_transposed| name_transposed.join(' ')}
  end

  def transpose_names(names, column_count = 3)
    row_count = names.length.quo(column_count).ceil
    # for transpose
    (row_count * column_count - names.length).times { names << '' }
    names_sliced = names.each_slice(row_count).to_a
    names_sliced.transpose
  end
end

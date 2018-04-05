class Hash

  # {"beep_boop"=>[{"abc_xyz"=>"mno"}, {"cheese_id"=>"wensleydale"}]}
  # を次に変換
  # {:beepBoop=>[{:abcXyz=>"mno"}, {:cheeseId=>"wensleydale"}]}
  def deep_camelize
    deep_transform_keys{ |key| key.to_s.camelize(:lower).to_sym }
  end

  # {:beepBoop=>[{:abcXyz=>"mno"}, {:CheeseID=>"wensleydale"}]}
  # を次に変換
  # {"beep_boop"=>[{"abc_xyz"=>"mno"}, {"cheese_id"=>"wensleydale"}]}
  def deep_snakeize
    deep_transform_keys { |key| key.to_s.underscore.to_sym }
  end
end


class Array
  # [{"abc_xyz"=>"mno"}, {"cheese_id"=>"wensleydale"}]
  # を次に変換
  # [{:abcXyz=>"mno"}, {:cheeseId=>"wensleydale"}]
  def deep_camelize
    collect(&:deep_camelize)
  end

  # [{:abcXyz=>"mno"}, {:CheeseID=>"wensleydale"}]
  # を次に変換
  # [{"abc_xyz"=>"mno"}, {"cheese_id"=>"wensleydale"}]
  def deep_snakeize
    collect(&:deep_snakeize)
  end
end

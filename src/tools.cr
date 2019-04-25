struct Pointer(T)
  def map_ptr_not_null(&block : T -> U) forall U
    p = self
    a = [] of U
    while !p.null? && !p.value.null?
      a.push yield(p.value)
      p += 1
    end
    a
  end
end

macro log_debug(str)
end

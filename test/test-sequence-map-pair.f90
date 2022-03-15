program TestSequenceMapPair

  use iso_c_binding
  use YAMLInterface
  use YAMLRead

  implicit none

  character(len=:), allocatable :: fpath
  type(YAMLHandler) :: domain
  type(YAMLSequence) :: seq
  type(YAMLMap) :: nested1
  type(YAMLMap) :: nested2
  type(YAMLElement) :: element
  integer :: n = -9999
  integer :: i = -9999
  integer :: code = 0

#ifdef _WIN64
  fpath = "..\..\bin\test.yaml" ! windows
#else
  fpath = "./test.yaml" ! linux
#endif

  domain = yaml_open_file(fpath)
  seq = yaml_start_from_sequence(domain, "sequence_type")

  element = seq%element(0)
  nested1 = element%value_map("nested_map")

  write(*,*) "map_nested.value1 = " , nested1%value_double("value1", code)
  write(*,*) "map_nested.another_value = " , nested1%value_double("another_value", code)

  nested2 = nested1%value_map("super_nested_map")
  write(*,*) "map_nested.super_nested_map.third_level_value = " , nested2%value_int_1d("third_level_value", code)

  call nested2%destroy()
  call nested1%destroy()
  call element%destroy()
  call seq%destroy()
  call yaml_close_file(domain)
  deallocate(fpath)

end program TestSequenceMapPair

program TestSequenceNest

  use iso_c_binding
  use YAMLInterface
  use YAMLRead

  character(len=:), allocatable :: fpath
  type(YAMLHandler) :: domain
  type(YAMLSequence) :: seq
  type(YAMLSequence) :: seq_nested
  type(YAMLElement) :: element
  type(YAMLElement) :: element_nest
  integer :: n = -9999
  integer :: i = -9999
  integer :: code = 0

#ifdef _WIN64
  fpath = "..\..\..\..\..\pkg\f-yaml\yaml-fortran\test\test.yaml" ! windows
#else
  fpath = "../pkg/f-yaml/yaml-fortran/test/test.yaml" ! linux
#endif

  domain = yaml_open_file(fpath)
  seq = yaml_start_from_sequence(domain, "sequence_type")

  element = seq%element(1)

  seq_nested = element%value_sequence("nested_sequence", code)

  n = seq_nested%size
  do i = 0,n-1
    element_nest = seq_nested%element(i)
    write(*,*) "Element ", element_nest%idx
    write(*,*) "  ", element_nest%value_double("interval", code)
    write(*,*) "  ", element_nest%value_double_1d("value", code)
    write(*,*) ""
    call element_nest%destroy()
  end do

  call seq_nested%destroy()
  call element%destroy()
  call seq%destroy()
  call yaml_close_file(domain)
  deallocate(fpath)

end program TestSequenceNest

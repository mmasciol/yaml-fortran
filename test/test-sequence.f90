program TestSequence

  use iso_c_binding
  use YAMLInterface
  use YAMLRead

  character(len=:), allocatable :: fpath
  type(YAMLHandler) :: domain
  type(YAMLSequence) :: seq
  type(YAMLElement) :: element_1
  type(YAMLElement) :: element_2
  integer :: n = -9999
  integer :: i = -9999
  integer :: code = 0

#ifdef _WIN64
  fpath = "..\..\..\..\..\pkg\f-yaml\yaml-fortran\test\test.yaml" ! windows
#else
  fpath = "./test.yaml" ! linux
#endif

  domain = yaml_open_file(fpath)
  seq = yaml_start_from_sequence(domain, "sequence_type")

  element_1 = seq%element(0)
  element_2 = seq%element(1)

  write(*,*) "string                 = ", element_1%value_str("item_is_string", code)
  write(*,*) "integer                = ", element_1%value_int("item_is_integer", code)
  write(*,*) "integer array          = ", element_1%value_int_1d("item_is_integer_array", code)
  write(*,*) "float                  = ", element_1%value_double("item_is_float", code)
  write(*,*) "float array            = ", element_1%value_double_1d("item_is_float_array", code)
  write(*,*) "integer array 2d       = ", element_1%value_int_2d("item_is_integer_array_2d", code)
  write(*,*) "integer array 2d (sym) = ", element_1%value_int_2d("item_is_integer_array_2d_symmetric", code)
  write(*,*) "float array 2d         = ", element_1%value_double_2d("item_is_float_array_2d", code)
  write(*,*) "float array 2d (sym)   = ", element_1%value_double_2d("item_is_float_array_2d_symmetric", code)
  write(*,*)
  write(*,*) "string                 = ", element_2%value_str("item_is_string", code)
  write(*,*) "integer                = ", element_2%value_int("item_is_integer", code)
  write(*,*) "integer array          = ", element_2%value_int_1d("item_is_integer_array", code)
  write(*,*) "float                  = ", element_2%value_double("item_is_float", code)
  write(*,*) "float array            = ", element_2%value_double_1d("item_is_float_array", code)
  write(*,*) "integer array 2d       = ", element_2%value_int_2d("item_is_integer_array_2d", code)
  write(*,*) "integer array 2d (sym) = ", element_2%value_int_2d("item_is_integer_array_2d_symmetric", code)
  write(*,*) "float array 2d         = ", element_2%value_double_2d("item_is_float_array_2d", code)
  write(*,*) "float array 2d (sym)   = ", element_2%value_double_2d("item_is_float_array_2d_symmetric", code)


  n = size(element_1%labels)
  write(*,*) "Available element keys:"
  do i = 1,n
    write(*,*) "  ", element_1%labels(i)%str
  end do

  call element_1%destroy()
  call element_2%destroy()
  call seq%destroy()
  call yaml_close_file(domain)
  deallocate(fpath)

end program TestSequence

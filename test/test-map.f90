program TestMap

  use iso_c_binding
  use YAMLInterface
  use YAMLRead

  character(len=:), allocatable :: fpath
  type(YAMLHandler) :: domain  ! be sure to close
  type(YAMLMap) :: parent
  type(YAMLMap) :: mapper_1
  type(YAMLMap) :: mapper_2
  integer :: n = -9999
  integer :: i = -9999
  integer :: code

#ifdef _WIN64
  fpath = "..\..\..\..\..\pkg\f-yaml\yaml-fortran\test\test.yaml" ! windows
#else
  fpath = "./test.yaml" ! linux
#endif

  domain = yaml_open_file(fpath)
  parent = yaml_start_from_map(domain, "parent")

  mapper_1 = parent%value_map("child1")
  mapper_2 = parent%value_map("child_22222")

  write(*,*) "mapper 1 = ", mapper_1%value_str("boolean_flag", code)
  write(*,*) "mapper 1 = ", mapper_1%value_double_1d("an_aray", code)
  write(*,*) "mapper 1 = ", mapper_1%value_int_2d("array_int_2d", code)
  write(*,*) ""
  write(*,*) "mapper 2 = ", mapper_2%value_str("boolean_flag", code)
  write(*,*) "mapper 2 = ", mapper_2%value_double_1d("an_aray", code)
  write(*,*) "mapper 2 = ", mapper_2%value_double_2d("array_float_2d", code)

  n = size(mapper_1%labels)
  write(*,*) ""//achar(13)//achar(10)//"Mapper 1 keys:"
  do i = 1,n
    write(*,*) "  ", mapper_1%labels(i)%str
  end do

  call mapper_1%destroy()

  n = size(mapper_2%labels)
  write(*,*) ""//achar(13)//achar(10)//"Mapper 2 keys:"
  do i = 1,n
    write(*,*) "  ", mapper_2%labels(i)%str
  end do

  call parent%destroy()
  call mapper_2%destroy()
  call yaml_close_file(domain)
  deallocate(fpath)

end program TestMap

/****************************************************************
 *   Copyright (C) 2016 mdm                                     *
 *                                                              *
 * Licensed to the Apache Software Foundation (ASF) under one   *
 * or more contributor license agreements.  See the NOTICE file *
 * distributed with this work for additional information        *
 * regarding copyright ownership.  The ASF licenses this file   *
 * to you under the Apache License, Version 2.0 (the            *
 * "License"); you may not use this file except in compliance   *
 * with the License.  You may obtain a copy of the License at   *
 *                                                              *
 *   http://www.apache.org/licenses/LICENSE-2.0                 *
 *                                                              *
 * Unless required by applicable law or agreed to in writing,   *
 * software distributed under the License is distributed on an  *
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY       *
 * KIND, either express or implied.  See the License for the    *
 * specific language governing permissions and limitations      *
 * under the License.                                           *
 ****************************************************************/


#ifndef ERROR_H
#define ERROR_H


typedef enum ERROR_CODE {
    SAFE     ,  // = 0 by default
    NOTE     ,  // = 1
    WARNING  ,  // = 2
    ERROR    ,  // = 3
    FATAL    ,  // = 4

    /* These are used internally to the program and are used to
     * map text to the specific error code */
    FATAL_4   , /* */
    ERROR_1   , /* */
    WARNING_1 , /* */
    NOTE_1    , /* */
} ERROR_CODE ;



#endif /* ERROR_H */

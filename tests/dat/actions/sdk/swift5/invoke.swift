/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

struct Result: Decodable {
  let date: String
}
struct Response: Decodable {
  let result:Result
}
struct Activation: Decodable {
  let response: Response
  let activationId: String
}

func main(args: Any) -> Any {
  let newArgs = args as! [String:Any]
  if let baseUrl = newArgs["baseUrl"] as? String {
    //Overriding WHISK API HOST using baseUrl, only applicable in testing with self sign ssl certs"
    Whisk.baseUrl = baseUrl
  }
  let invokeResult = Whisk.invoke(actionNamed: "/whisk.system/utils/date", withParameters: [:])
  let jsonData = try! JSONSerialization.data(withJSONObject: invokeResult)
  let dateActivation = try! JSONDecoder().decode(Activation.self, from: jsonData)
  let dateString = dateActivation.response.result.date
  if dateString.isEmpty{
      print("Could not parse date of of the response.")
  } else {
      print("It is now \(dateString)")
  }
  // return the entire invokeResult
  return invokeResult
}

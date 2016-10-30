import Vapor
import BSON

let drop = Droplet()


// MARK: - Challenge 1
// This is a example of a GET request on Vapor to say "Hello, World!".
drop.get("") { req in
    return "Hello, Trevin! Your code is working just fine. Go ahead and finish the challenges!"
}


// MARK: - Testing
// Making a POST request to create the JSON data.
/* drop.post("test") { req in
    
    guard let input_json = req.json else {
        throw Abort.badRequest
    }
    
    let dictionary = ["todo" : "Finish API Design challenge"]

    return try JSON(node: dictionary)
} */

// Making GET request to retrieve the JSON data.
drop.get("test") { req in
    
    guard let input_json = req.json else {
        throw Abort.badRequest
    }
    
    return try JSON(node: input_json)
}




// MARK: - Challenge 2
/*
 This is a challenge to make a POST request,
 check if the keys "name", "age" and "species"
 exist and append the JSON data to an array.
 */

// listOfJSON contains a list of JSON data.
var listOfJSON: [JSON] = []


// Post request.
drop.post("reminders") { req in
    
    // Asking for three parameters, else throw a bad request.
    /*    guard let name = req.json?["name"], let age = req.json?["age"], let species = req.json?["species"] else {
     throw Abort.badRequest
     }
     */
    
    // input_json contains the JSON data.
    guard let input_json = req.json else {
        throw Abort.badRequest
    }
    
    // Checks if the keys "name", "age" and "species" exist.
    if let name = input_json["name"], let age = input_json["age"], let species = input_json["species"] {
        
        // Loops through the listOfJSON array to check if a name already exists.
        for data in listOfJSON {
            // If there is a name that exists.
            if name == data["name"] {
                // Throw an error.
                return "HTTP 409 ERROR: NAME IS NOT UNIQUE"
            }
        }
        
        // If successeful, it appends the data received to the listOfJSON array.
        listOfJSON.append(input_json)
        return "Successfully appended."
        
    } else {
        
        // Identifies which key is missing.
        if input_json["name"] == nil {
            // If not, it will notify the error.
            return "Failed to append. Key dictionary 'name' missing."
        } else if input_json["age"] == nil {
            // If age is missing.
            return "Failed to append. Key dictionary 'age' missing."
        } else {
            // If species is missing.
            return "Failed to append. Key dictionary 'species' missing."
        }
        
    }
    
}

// Makes a GET request to retreive the array to see what's inside.
drop.get("pets") { req in
    return try JSON(node: listOfJSON)
}

// MARK: - Challenge 3
// Makes a GET request to retrieve the specific name.
// String.self refers to the <name> in /pets/<name>
// name is a variable that is referenced to String.self
drop.get("pets", String.self) { req, name in
    // Loops through all the existing JSON data in the array.
    for data in listOfJSON {
        // If the name of the string matches with the value of the key "name".
        if name == data["name"]?.string {
            // Return the JSON data of it
            return try JSON(node: data)
        }
    }
    
    return "HTTP 404 ERROR."
}


// MARK: - Challenge 4
// PUT request to replace the data related to the name.
drop.put("pets", String.self) { req, name in
    // When request is sent, the JSON Data is captured on newData.
    guard let newData = req.json else {
        throw Abort.badRequest
    }
    
    // Loops through the listOfJSON.
    for object in listOfJSON {
        // Checks if the name of the parameter matches to any in the listOfJSON.
        if name == object["name"]?.string {
            // Finding the index number of the object that matches.
            let indexNumber = listOfJSON.index(of: object)
            // Replaces the specific object by referencing its index number.
            listOfJSON[Int(indexNumber!)] = newData
            // Returns the updated data.
            return try JSON(node: newData)
        }
    }
    
    return "HTTP 404 ERROR."
}


// MARK: - Challenge 5
// TODO: - Complete the "DELETE" request
drop.delete("pets", String.self) { req, name in
    guard let dataRequested = req.json else {
        throw Abort.badRequest
    }
    
    // Loops through the listOfJSON.
    for object in listOfJSON {
        // Checks if the name of the parameter matches to any in the listOfJSON.
        if name == object["name"]?.string {
            // Finding the index number of the object that matches.
            let indexNumber = listOfJSON.index(of: object)
            // Uses index number to delete the specific object based on name.
            listOfJSON.remove(at: Int(indexNumber!))
            // Returns the updated data.
            return try JSON(node: listOfJSON)
        }
    }
    
    return "HTTP 404 ERROR"
}



drop.resource("posts", PostController())

drop.run()

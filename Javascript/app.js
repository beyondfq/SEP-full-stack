// JavaScript Exercise
// Q1 Write the code to sum all salaries and store in the variable sum. 
let Salaries = {
    John: 100,
    Ann: 160,
    Pete: 130
}

var sum = Salaries.John + Salaries.Ann + Salaries.Pete;
console.log(sum);


// Q2 Create a function multiplyNumeric(obj) that multiplies all numeric properties of obj by 2
let menu = {
    width: 200,
    height: 300,
    title: "My menu"
}
console.log(menu);

function multiplyNumeric(obj) {
    for (let key in obj) {
        if (typeof (obj[key]) == "number") {
            obj[key] = obj[key] * 2;
        }
    }
}
multiplyNumeric(menu);
console.log(menu);


// Q3 Write a function checkEmailId(str) that returns true if str contains '@' and ‘.’, otherwise false. 
// Make sure '@' must come before '.' and there must be some characters between '@' and '.'
function checkEmailId(str)
{
    var flag = 0;
    var len = str.length;
    for (var i = 0; i < len; i++)
    {
        if (str[i] == '@' && flag == 0){
            flag += 1;         
        } 
        if (str[i] == '.' && str[i-1] != '@' && flag != 0){
            flag += 1;
        }
    }
    if (flag < 2)
        return "It is not an Email ID."
    else
        return "It is an Email ID."
}

var email = "abc@gamil.com";
console.log(checkEmailId(email));

var email = "a.b.c@gmail.com";
console.log(checkEmailId(email));

var email = "a.b.cgmail.com";
console.log(checkEmailId(email));


// Q4 Create a function truncate(str, maxlength) that checks the length of the str and, 
// if it exceeds maxlength–replaces the end of str with the ellipsis character "...", 
//to make its length equal to maxlength.
function truncate(str, maxlength)
{
    var len = str.length;
    if (len <= maxlength)
        return str;
    else {
        return str.substring(0,maxlength-1) + "..."
    }
}

var str = "What I'd like to tell on this topic is:";
var maxlength = 20;
console.log(truncate(str, maxlength));

var str = "Hi everyone!";
var maxlength = 20;
console.log(truncate(str, maxlength));


// Q5 Create an array styles with items “James” and “Brennie”.
const names = ["James", "Brennie"];
console.log(names);

// Append “Robert” to the end.
names.push("Robert");
console.log(names);

// Replace the value in the middle by “Calvin”. 
// Your code for finding the middle value should work for any arrays with odd length.
len = names.length;
pos = Math.floor(len/2);
names[pos] = "Calvin";
console.log(names);

// Remove the first value of the array and show it.
names.shift(names);
console.log(names);

// Prepend Rose and Regal to the array.
names.splice(0,0, "Rose", "Regal");
console.log(names);
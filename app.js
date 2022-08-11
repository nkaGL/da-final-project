//jshint esversion:6
const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const _ = require("lodash");
//const date = require(__dirname + "/date.js");
const app = express();
const port = 8080;

app.set('view engine', 'ejs');

app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static("public"));

mongoose.connect("mongodb://localhost:27017/todolistDB", {useNewUrlParser: true});
//mongoose.connect("mongodb+srv://ninaro:Test-123@clustertodo.haowzbs.mongodb.net/todolistDB", {useNewUrlParser: true});

//mongoose.connect("mongodb://ninaro:Test-123@docdb-2022-08-08-21-13-58.cluster-ce6w7hpdusy3.eu-central-1.docdb.amazonaws.com:27017/", {useNewUrlParser: true, useUnifiedTopology: true});
//mongoose.connect("mongodb://ninaro:Test-123@docdb-2022-08-08-21-13-58.ce6w7hpdusy3.eu-central-1.docdb.amazonaws.com:27017/?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&retryWrites=false",
//{tlsCAFile: `/aws-cert/rds-combined-ca-bundle.pem`});

const itemsSchema = { name: String };
const Item = mongoose.model("Item", itemsSchema);

const item1 = new Item({
  name: "Hit the + button to add a new item."
});
const item2 = new Item({
  name: "<-- Hit checkbox to delete an item."
});

const listSchema = {
  name: String,
  items: [itemsSchema]
};
const List = mongoose.model("List", listSchema);


const defaultItems = [item1, item2];

  app.get("/", function(req, res) {
    Item.find({}, function(err, foundItems){
      if (foundItems.length === 0) {
        Item.insertMany(defaultItems, function(err){
          if (err) {
            console.log(err);
          } else {
            console.log("Successfully saved default items to DB.");
          }
        });
        res.redirect("/");
      } else {
        res.render("list", {listTitle: "Today", newListItems: foundItems});
      }
    });
  });

  app.get("/:customListName", function(req, res){
    const customListName = _.capitalize(req.params.customListName);
  
    List.findOne({name: customListName}, function(err, foundList){
      if (!err){
        if (!foundList){
          //Create a new list
          const list = new List({
            name: customListName,
            items: defaultItems
          });
          list.save();
          res.redirect("/" + customListName);
        } else {
          //Show an existing list
          res.render("list", {listTitle: foundList.name, newListItems: foundList.items});
        }
      }
    });
  });

  app.post("/", function(req, res) {
    const itemName = req.body.newItem;
    const listName = req.body.list;

    const item = new Item({
      name: itemName
    });
    
    if (listName === "Today"){
      item.save();
      res.redirect("/");
    } else {
      List.findOne({name: listName}, function(err, foundList){
        foundList.items.push(item);
        foundList.save();
        res.redirect("/" + listName);
      });
    }

  });

  app.post("/delete", function(req, res){
    const checkedItemId = req.body.checkbox;
    const listName = req.body.listName;

    if (listName === "Today") {
      Item.findByIdAndRemove(checkedItemId, function(err){
        if (!err) {
          console.log("Successfully deleted checked item.");
          res.redirect("/");
        }
      });
      } else {
        List.findOneAndUpdate({name: listName}, {$pull: {items: {_id: checkedItemId}}}, function(err, foundList){
          if (!err){
            res.redirect("/" + listName);
          }
      });
    }
  });

  app.get("/work", function(req, res) {
    res.render("list", {listTitle: "Work List", newListItems: workItems});
  });

  app.get("/about", function(req, res){
    res.render("about");
  });

  app.listen(port, function(){
    console.log(`Server started on port ${port}`);
    });

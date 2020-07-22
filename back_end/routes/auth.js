var express = require('express');
var router = express.Router();
const bcrypt = require('bcryptjs');
const { promisify } = require('util');
const crypto = require('crypto');
const user = require('../models/User');
const parcel=require('../models/parcel');
const payment=require('../models/payment');
const notification=require('../models/notification');
var nodemailer = require('nodemailer');
var transporter = nodemailer.createTransport({ service: "gmail", auth: { user: 'oohas1234@gmail.com', pass: '9840290558' } });
router.get('/login', function (req, res) {
  const data = {};

  data.title = 'Login';
  // data.errors = req.flash('error');
  
  res.render('../views/login', data);
});
router.post('/parcel',(req,res)=>{
  const newparcel = parcel(body)
  
  
  newparcel.save()
  res.status(200).json({msg:"saved"});
})
router.get('/signup', function (req, res) {
  const data = {};

  data.title = 'Signup';
  // data.errors = req.flash('error');
  console.log("sorry")
  res.render('../views/signup', data);
});

router.get('/logout', function (req, res) {
  req.logout();
  res.redirect('/auth/login');
});


router.post('/signup', async function (req, res, next) {

  const body = req.body;

  if (body.email) {
    /** Find if email exists or not */
    const existing = await user.findOne({ email: body.email }).countDocuments();

    if (existing) {
      /** Set flash message and redirect to signup page */
      req.flash('error', 'User Already Exists');
      return res.redirect('/auth/signup');
    }

    /**
     * Hash password and save it into database
     */
    const salt = await bcrypt.genSalt(10);
    body.password = await bcrypt.hash(body.password, salt);
    console.log(body.password)
    try {
      const newUser = new user(body);
      await newUser.save();
        
      /**
       * Manually authenticating user
       * comment the following lines and redirect to login page for authenticating.
       */
      
      console.log('hiiiiiii')
      const link = `http://10.0.2.2:5000/auth/verify/${body.email}`
        const resetEmail = {
          to: body.email,
          from: 'oohas1234@gmail.com',
          subject: 'Cachy_courrier email verification',
          html: `Hello,<br> Please Click on the link to verify your email.<br><a href="${link}">${link}</a>`,
        }

        console.log('80')
        transporter.sendMail(resetEmail, function (err) {
          if (err) {
            console.log("bass11");
            console.log(err.message)
            res.status(500).send({ msg: err.message });
          }
        });


      req.logIn(newUser, function () {
        // res.render('../views/home');
        res.status(200).json(newUser);
      });
    } catch (error) {
      console.log(error)
      return res.status(500).json({message: error.message})
    }
  }
})

router.get('/forgot', (req, res, next) => {
  const data = {}
  data.title = 'Login';
  // data.errors = req.flash('error');

  res.render('../views/forgot', data);

});

router.post('/forgot', async (req, res, next) => {
  const token = (await promisify(crypto.randomBytes)(20)).toString('hex');
  const body = req.body
  console.log(body.email)
  user.find({ email: body.email })
    .exec()
    .then(
      enter_user => {
        if (enter_user.length < 1) {
          res.status(404).json({msg:'user not found'})
        
        }



        enter_user[0].resetPasswordToken = token;
        enter_user[0].resetPasswordExpires = Date.now() + 3600000;
        enter_user[0].save(function (err) {
          if (err) { return res.status(500).send({ msg: err.message }); }
        });
        const link = `http://10.0.2.2:5000/auth/reset/${token}`
        const resetEmail = {
          to: enter_user[0].email,
          from: 'tunuguntlaooha1234@gmail.com',
          subject: 'Cachy_courrier Password Reset',
          html: `Hello,<br> Please Click on the link to change password.<br><a href="${link}">${link}</a>`,
        }


        transporter.sendMail(resetEmail, function (err) {
          if (err) {
            console.log("bass");
            res.status(500).send({ msg: err.message });
          }
          
          res.status(200).json({msg:'mail sent'})
        });
       
      })

});
router.get('/verify/:email',(req,res)=>{
  user.find({email:req.params.email})
  .exec()
  .then(
    verify_user=>{
      if (verify_user.length < 1) {
        return res.send('no user')
      }
      verify_user[0].isVerified=true;
      verify_user[0].save();
      res.render('../views/home');
    }
  )
})

router.get('/reset/:token', (req, res) => {
  user.find({ resetPasswordExpires: { $gt: Date.now() }, resetPasswordToken: req.params.token })
    .exec()
    .then(

      enter_user => {
        if (enter_user.length < 1) {
          res.send('Password reset token is invalid or has expired')
         
        }


        data = {}
        data.token = enter_user[0].resetPasswordToken
        
        res.render('../views/reset', data);


      });
});

router.post('/reset/:token', async function (req, res,next){
  const salt = await bcrypt.genSalt(10);
  const pass = await bcrypt.hash(req.body.password, salt);
  user.find(
    { resetPasswordExpires: { $gt: Date.now() }, resetPasswordToken: req.params.token }
  )
    .exec()
    .then(
      enter_user => {
        if (enter_user.length < 1) {
          return res.send('Password reset token is invalid or has expired')
        }

       
        console.log(req.body.password)
        enter_user[0].password = pass
        // delete enter_user[0].resetPasswordToken;
        // delete enter_user[0].resetPasswordExpires;
        enter_user[0].save();
        const resetEmail = {
          to: enter_user[0].email,
          from: 'tunuguntlaooha1234@gmail.com',
          subject: 'Your password has been changed',
          text: `
        This is a confirmation that the password for your account "${enter_user[0].email}" has just been changed.`,
        };
        transporter.sendMail(resetEmail, function (err) {
          if (err) {
            console.log("bass");
            res.status(500).send({ msg: err.message });
          }
          
          
          req.logIn(enter_user[0], function () {
           res.render("../views/home")
          });
        });
       
        
        
      });
});

router.get('/success',(req,res)=>{
  console.log('sucess')
  res.status(200).json();
})

router.get('/failure',(req,res)=>{
  console.log('fail')
  res.status(500).json();
})
router.get('/sendnotification', async function(req,res,next){
  deliveryemail="venkat9989383223@gmail.com"
  sourceemail="oohas1234@gmail.com"
  //
  const deliveryguydetails=await user.findOne({email:deliveryemail});
  deliveryguymobilenumber=deliveryguydetails['mobilenumber'];
  //
  const parceldetails = await parcel.findOne({ id:'1' });
  id=parceldetails['id']
  sourceaddress=parceldetails['sourceaddress']
  destinationaddress=parceldetails['destinationaddress']
  parceltype=parceldetails['parceltype']
  cost=parceldetails['cost']
  //
  const paymentdetails=await payment.findOne({id:id});
  ispaid=paymentdetails['ispaid']
  const link = `http://10.0.2.2:5000`
 if(ispaid) {
    const sendnotificationtodeliveryguy = {
    to: deliveryemail,
    from: 'tunuguntlaooha1234@gmail.com',
    subject: 'Cachy_courrier delivery assignment',
    //html: `Hello,<br> Please Click on the link to verify your email.<br><a href="${link}">${link}</a>`,
    html:`Hello ${deliveryemail},<br>You are assigned to parcelid ${id} and details are as follows:<br>
    sourceaddress:${sourceaddress}<br>
    destinationaddress:${destinationaddress}<br>
    parceltype:${parceltype}<br>
    Payment is already done
     `
    
  }
  transporter.sendMail(sendnotificationtodeliveryguy,async function (err) {
    if (err) {
      console.log("didnot send email to  delivery guy assignment");
      res.status(500).send({ msg: err.message });
    }
    else{
      newnotify={'email':sendnotificationtodeliveryguy['to'],'notificationtext':sendnotificationtodeliveryguy['html']}
      const newnotification=new notification(newnotify)
      console.log(newnotification)
      await newnotification.save()
    }
  });
  
}
else{
  
    const sendnotificationtodeliveryguy = {
    to: deliveryemail,
    from: 'tunuguntlaooha1234@gmail.com',
    subject: 'Cachy_courrier delivery assignment',
    //html: `Hello,<br> Please Click on the link to verify your email.<br><a href="${link}">${link}</a>`,
    html:`Hello ${deliveryemail},<br>You are assigned to parcelid ${id} and details are as follows:<br>
    sourceaddress:${sourceaddress}<br>
    destinationaddress:${destinationaddress}<br>
    parceltype:${parceltype}<br>
    payment:Cash on delivery<br>
    cost:${cost}<br>
    Please Click on the link to know route of customer .<br><a href="${link}">route</a>
  ` 
  }
  transporter.sendMail(sendnotificationtodeliveryguy, async function (err) {
    
    if (err) {
      console.log("didnot send email to delivery guy assignment");
      res.status(500).send({ msg: err.message });
    }
    else{
      newnotify={'email':sendnotificationtodeliveryguy['to'],'notificationtext':sendnotificationtodeliveryguy['html']}
      const newnotification=new notification(newnotify)
      console.log(newnotification)
      await newnotification.save()
    }
    
  });
}
const sendnotificationtocustomer = {
  to: sourceemail,
  from: 'tunuguntlaooha1234@gmail.com',
  subject: 'Cachy_courrier parcel',
  //html: `Hello,<br> Please Click on the link to verify your email.<br><a href="${link}">${link}</a>`,
  html:`Hello ${sourceemail},<br>Your parcelid ${id} is assigned to ${deliveryemail} and contact his mobilenumber:${deliveryguymobilenumber} for urgent queries<br>
  Please Click on the link to track path of your courrier .<br><a href="${link}">${link}</a>`
}
transporter.sendMail(sendnotificationtocustomer,async function (err) {
  if (err) {
    console.log("didnot send email to  customer");
    res.status(500).send({ msg: err.message });
  }
  else{
    newnotify={'email':sendnotificationtocustomer['to'],'notificationtext':sendnotificationtocustomer['html']}
    const newnotification=new notification(newnotify)
    console.log(newnotification)
    await newnotification.save()
  }
});

});
// router.get('/sendnotificationtocustomer',async function(req,res){
//   console.log('hiii')
//   deliveryemail="venkat9989383223@gmail.com"
//   const deliveryguydetails=await user.findOne({email:deliveryemail});
//   deliveryguymobilenumber=deliveryguydetails['mobilenumber'];
//   const parceldetails = await parcel.findOne({ id:'1' });
//   id=parceldetails['id']
//   sourceemail=parceldetails['email']
//   //cost=parceldetails['cost']
//   // const paymentdetails=await payment.findOne({id:id});
//   // ispaid=paymentdetails['ispaid']
//   const link = `http://${process.env.ipadress}:${process.env.port}`
 
// const sendnotificationtocustomer = {
//   to: sourceemail,
//   from: 'tunuguntlaooha1234@gmail.com',
//   subject: 'Cachy_courrier parcel',
//   //html: `Hello,<br> Please Click on the link to verify your email.<br><a href="${link}">${link}</a>`,
//   html:`Hello ${sourceemail},<br>Your parcelid ${id} is assigned to ${deliveryemail} and contact his mobilenumber:${deliveryguymobilenumber} for urgent queries<br>
//   Please Click on the link to track path of your courrier .<br><a href="${link}">${link}</a>`
// }
// transporter.sendMail(sendnotificationtocustomer, function (err) {
//   if (err) {
//     console.log("didnot send email to  customer");
//     res.status(500).send({ msg: err.message });
//   }
// });


 

// })

module.exports = function (passport) {

  router.post('/login',
    passport.authenticate('local'),
    function(req,res){

        console.log("success")
        res.status(200).json({msg:'success'});
    
    }
    
    );

  return router;
};
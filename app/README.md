# labourchowk

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VS Code](https://code.visualstudio.com/) + [Vue (Official)](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Recommended Browser Setup

- Chromium-based browsers (Chrome, Edge, Brave, etc.):
  - [Vue.js devtools](https://chromewebstore.google.com/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd) 
  - [Turn on Custom Object Formatter in Chrome DevTools](http://bit.ly/object-formatters)
- Firefox:
  - [Vue.js devtools](https://addons.mozilla.org/en-US/firefox/addon/vue-js-devtools/)
  - [Turn on Custom Object Formatter in Firefox DevTools](https://fxdx.dev/firefox-devtools-custom-object-formatters/)

## Customize configuration

See [Vite Configuration Reference](https://vite.dev/config/).

# how to chnage icon and text
1. change bharat iocn go to thsi and replace. 
- src\assets\bharat.jpg
- if u want to change from header go this two componnet and change (  <img src="@/assets/bharat.jpg" )-
- src\components\header\BackButtonAppBar.vue
- src\components\header\LogoutAppBar.vue
2. change home page content goto -
 - src\views\Home.vue

3. if add otp services - u have to implemtn it on this pages -
# worker
- src\views\WorkerRegister.vue
- src\views\WorkerLogin.vue
- src\views\WorkerFrogotPassword.vue

# -employer 
- src\views\EmployerRegister.vue
- src\views\EmployerLogin.vue
- src\views\EmployerForgotPassword.vue

4. Add mapmyindia api for map
   - first u have too register mapmyindia - https://www.mapmyindia.com/
   - on  dashoboard ->projects->select Project->credentials->Default Key ,
   - copy that key and paste it on - src\services\apiRoutes.js
   -  location- mapSecretKey: '95ef3999d1bf25e4ce8364342c3e61d25', 
   -  change this key - '95ef3999d1bf25e4ce8364342c3e61d25',

5. How to chnage launcher icon 

Step 1: Right-click the app folder

In Android Studio Project panel:

app → res → Right-click → New → Image Asset

Step 2: Select Icon Type

A window will open:

Icon Type: Launcher Icons (Adaptive and Legacy)

Asset Type:
✔ Image (if you have PNG/JPG)
✔ Vector (if SVG)

Then browse and select your icon image.

Step 3: Adjust settings

You can configure:

Background Layer

Foreground Layer

Scaling

Padding


## Project Setup

```sh
#npm install
```
1. add api base url on - src\services\api.js
 --baseURL: "{http://localhost/labourchowk/api/public/api/}",
### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Compile and Minify for Production

```sh
npm run build
```
# for android
npx cap copy
# need installed android studio 
npx cap open android

# how to build debug apk
 in android studio - build->Generate App bundles or Apk

# how to buils singned apk for google play console /play store
in android studio -  Build → Generate Signed App Bundle / APK


how to generate BOTH Signed APK and Signed AAB.

✅ Step 1: Create a Keystore (Signing Key)
Android Studio

Open Android Studio

Click Build → Generate Signed App Bundle / APK

Choose:

Android App Bundle (Recommended) → AAB
OR

APK

Click Next

Click Create new…

Fill in:

Keystore path: choose a folder to save my-release-key.jks

Password: create one

Alias: create a name (example: uploadkey)

Alias password: create one

Validity: 25+ years recommended

Fill out personal info

Click OK

✅ Step 2: Build the Signed AAB / APK

In the wizard:

Select the keystore you created

Enter:

Keystore password

Alias name

Alias password

Select release

Click Next

Choose destination folder

Click Finish

🎉 Android Studio will now generate:

If AAB selected:
app-release.aab

If APK selected:
app-release.apk


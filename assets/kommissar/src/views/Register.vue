<template>
  <div class="Register">
    <div class="ui container">
      <h1>Register</h1>
      <div class="ui segment">
        <div v-if="errors" class="ui error message">
          <ul v-for="(error, index) in formattedErrors" :key="index">
            <li>{{ error }}</li>
          </ul>
        </div>
        <form class="ui form" v-on:submit.prevent="register">
          <div class="field">
            <label>Username</label>
            <input type="text" name="username" v-model="user.username" placeholder="Patatoid">
          </div>
          <div class="field">
            <label>Password</label>
            <input type="password" v-model="user.password" name="password">
          </div>
          <button class="ui fluid button" type="submit">Register</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import User from '@/models/user.model'

export default {
  name: 'register',
  data () {
    return {
      user: new User(),
      errors: null
    }
  },
  computed: {
    formattedErrors () {
      const { errors } = this
      return Object.keys(errors).map((error) => `${error} : ${errors[error]}`)
    }
  },
  methods: {
    async register () {
      this.errors = null
      try {
        await this.user.save()
        this.$router.push({ name: 'login' })
      } catch (errors) {
        this.errors = errors
      }
    }
  }
}
</script>

<style>
</style>

<template>
  <div class="login">
    <div class="ui container">
      <h1>Login</h1>
      <div class="ui segment">
        <div v-if="error" class="ui error message">
          {{ error }}
        </div>
        <form class="ui form" v-on:submit.prevent="login">
          <div class="field">
            <label>Username</label>
            <input type="text" name="username" v-model="user.username" placeholder="Patatoid">
          </div>
          <div class="field">
            <label>Password</label>
            <input type="password" v-model="user.password" name="password">
          </div>
          <button class="ui fluid button" type="submit">Login</button>
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
      error: null
    }
  },
  methods: {
    async login () {
      this.error = null
      try {
        await this.user.login()
        this.$store.dispatch('setUser', this.user)
        this.$router.push({ name: 'home' })
      } catch (error) {
        this.error = error
      }
    }
  }
}
</script>

<style>
</style>

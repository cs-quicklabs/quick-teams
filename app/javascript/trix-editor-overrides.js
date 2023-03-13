window.addEventListener("trix-file-accept", function(event) {
    const acceptedTypes = ['image/jpeg','image/jpg', 'image/png','application/pdf']
    if (!acceptedTypes.includes(event.file.type)) {
      event.preventDefault()
      alert("Only JPEG, JPG, PNG and PDF files are supported!")
    }
  })
  window.addEventListener("trix-file-accept", function(event) {
    const maxFileSize =10*1024*1024
    if (event.file.size > maxFileSize) {
      event.preventDefault()
      alert("Only supports attachment files upto size 10MB!")
    }
  })
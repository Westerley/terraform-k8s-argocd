resource "null_resource" "k3d_cluster" {

  provisioner "local-exec" {
    command = "k3d cluster create pucminas"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "k3d cluster delete pucminas"
  }

}
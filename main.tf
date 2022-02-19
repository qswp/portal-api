locals {
  lambda_assume_role_policy = {
    lambda = {
      actions = ["sts:AssumeRole"]
      principals = {
        lambda_principal = {
          type = "Service"
          identifiers = ["lambda.amazonaws.com"]
        }
      }
    }
  }

  dynamodb_to_item_vtl = <<END
#set($item = $input.path('$.Items[0]'))
{
#foreach($key in $item.keySet())
  #foreach($type in $item.get($key).keySet())
    #set($value = $util.escapeJavaScript($item.get($key).get($type)))
    "$key": #if($type == "S")"#end$value#if($type == "S")"#end
  #end
  #if($foreach.hasNext),#end
#end
}
END

  dynamodb_to_array_vtl = <<END
#set($inputRoot = $input.path('$'))
[
#foreach($item in $inputRoot.Items) {
  #foreach($key in $item.keySet())
    #foreach($type in $item.get($key).keySet())
      #set($value = $util.escapeJavaScript($item.get($key).get($type)))
      "$key": #if($type == "S")"#end$value#if($type == "S")"#end
    #end
    #if($foreach.hasNext),#end
  #end 
}
#if($foreach.hasNext),#end
#end
]
END
}

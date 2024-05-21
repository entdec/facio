
| servitium      | explanation                          | facio                          | explanation                                            |
| -------------- | ------------------------------------ | ------------------------------ | ------------------------------------------------------ |
| context.valid? | is the context valid?                | context.valid?                 |                                                        |
| success?       | did the service complete succesfully | success?                       | only when using perform                                |
| -              | -                                    | service.successfully_enqueued? | only when using perform_later (it returns the service) |
| failed?        | reverse of success                   | success?                       |                                                        |
| failure?       | reverse of success                   | success?                       |                                                        |
| fail?          | reverse of success                   | success?                       |                                                        |

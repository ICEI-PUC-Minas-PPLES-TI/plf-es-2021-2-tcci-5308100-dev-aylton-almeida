final _appBarTitles = {
  'supplier_account_title': 'Sua Conta',
  'delivery_list_title': 'Lista de Ofertas',
  'delivery_details': 'Detalhes da Oferta',
  'order_details': 'Detalhes do Pedido',
  'order_problems': 'Problemas na Entrega',
};

final _headers = {
  'delivery_code_form_header':
      'Você possui um código para realizar uma entrega?',
  'phone_form_deliverer_header':
      'Antes de acessar a rota de entrega, insira seu número de WhatsApp',
  'phone_form_supplier_header':
      'Parceiro, acesse sua conta com seu número de WhatsApp',
  'confirmation_code_form_header': 'Digite o código de confirmação',
  'recipient_name': 'Destinatário: :name',
  'order_problem_header': 'Qual o problema ocorrido durante a entrega?',
  'delivery_complete_header': 'Obrigado!'
};

final _subHeaders = {
  'delivery_code_form_subheader':
      'Caso não, mas deseje ver suas entregas pendentes, acesse sua conta de parceiro Trela',
  'phone_form_subheader':
      'Digite seu WhatsApp para entrar. Seus dados estão seguros e você não precisa de senha.',
  'confirmation_code_form_subheader':
      'Insira o código de 6 dígitos que enviamos para o seu WhatsApp :phone',
  'next_delivery': 'Próxima Entrega:',
  'order_problem_subheader':
      'Nos diga qual o tipo de problema ocorrido e de detalhes do acontecido.',
  'delivery_complete_subheader': 'Você finalizou todos os pedidos da entrega.'
};

final _listTitles = {
  'supplier_data': 'Dados da empresa',
  'products_list': 'Produtos'
};

final _listContent = {
  'delivery_list_no_deliveries': 'Nenhuma entrega encontrada',
  'delivery_created_subtitle': 'Entrega prevista: dia :day às :hour horas',
  'delivery_in_progress_subtitle': 'Entrega prevista: dia :day às :hour horas',
  'delivery_finished_subtitle': 'Entregue: dia :day às :hour horas',
  'delivery_initial_address': 'Endereço inicial: :address',
  'delivery_address': 'Endereço: :address',
  'delivery_estimate_time': 'Tempo estimado: :hour horas e :minute minutos',
};

final _inputLabels = {
  'delivery_code_input_label': 'Código de 6 dígitos',
  'phone_input_label': 'Telefone',
  'confirmation_code_input_label': 'Código de 5 dígitos'
};

final _inputHints = {
  'code_input_hint': 'Código',
  'phone_input_hint': 'Telefone completo',
  'order_problem_select_hint': 'Selecione um problema...',
  'order_problem_input_hint': 'Descreva um pouco do ocorrido...'
};

final _dropdownOptions = {
  'missing_product': 'Produto não disponível',
  'absent_receiver': 'Destinatário ausente'
};

final _formValidation = {
  'empty_delivery_code_input_error': 'Digite o código de entrega',
  'invalid_delivery_code_input_error': 'Código de entrega invalido',
  'invalid_phone_input_error': 'Insira um telefone válido',
  'empty_confirmation_code_input_error': 'Digite o código de confirmação',
  'invalid_confirmation_code_input_error': 'Código de confirmação invalido',
};

final _buttonLabels = {
  'verify_code_button': 'Verificar código de entrega',
  'trela_partner_button': 'Sou um parceiro trela',
  'phone_form_deliverer_button': 'Ver detalhes da entrega',
  'phone_form_supplier_button': 'Receber código por WhatsApp',
  'confirmation_code_button': 'Verificar',
  'resend_code_button': 'Reenviar código',
  'change_number_button': 'Trocar número de celular',
  'exit_button': 'Sair',
  'share_delivery_with_deliverer': 'Enviar para Entregador',
  'start_delivery': 'Iniciar entrega',
  'cancel_delivery': 'Cancelar entrega',
  'cancel': 'Cancelar',
  'confirm': 'Confirmar',
  'view_details': 'Ver detalhes',
  'confirm_delivery': 'Confirmar entrega',
  'register_problem': 'Registrar problema',
  'send_problem': 'Enviar problema',
  'go_back_to_start': 'Voltar para página inicial'
};

final _alerts = {
  'phone_not_registered_error':
      'Este telefone não possuí uma conta de parceiro Trela.',
  'invalid_confirmation_code_error':
      'Código inválido. Verifique-o e tente novamente',
  'generic_error_msg': 'Ocorreu um erro, tente novamente mais tarde.',
  'resend_code_success_message':
      'Código de autenticação reenviado com sucesso.',
  'location_permission_error':
      'Para realizar a entrega precisamos de sua localização. Por favor habilite a localização.',
  'refresh_directions': 'Recalculando rota...',
  'delivery_confirmed': 'Entrega confirmada',
  'problem_registered': 'Problema registrado',
};

final _tabs = {
  'pending': 'Pendentes',
  'in_progress': 'Em andamento',
  'delivered': 'Entregues',
  'products': 'Produtos',
  'orders': 'Pedidos'
};

final _shareMessages = {
  'share_with_deliverer':
      'Olá, aqui está o código de acesso à entrega :name: :code'
};

final _dialogTitles = {
  'start_delivery_dialog_title':
      'Você tem certeza que deseja iniciar essa entrega?',
  'cancel_delivery_dialog_title':
      'Você tem certeza que deseja cancelar essa entrega?',
};

final _dataLabels = {
  'address': 'Endereço:',
  'delivery_time': 'Hora de Entrega:',
};

final Map<String, String> ptBR = {
  ..._appBarTitles,
  ..._headers,
  ..._subHeaders,
  ..._listTitles,
  ..._listContent,
  ..._inputLabels,
  ..._inputHints,
  ..._dropdownOptions,
  ..._formValidation,
  ..._buttonLabels,
  ..._alerts,
  ..._tabs,
  ..._shareMessages,
  ..._dialogTitles,
  ..._dataLabels
};

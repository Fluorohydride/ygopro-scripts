--閃刀機関－マルチロール
function c24010609.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24010609,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c24010609.tgtg)
	e2:SetOperation(c24010609.tgop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24010609,1))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c24010609.settg)
	e3:SetOperation(c24010609.setop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c24010609.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetOperation(c24010609.regop2)
	c:RegisterEffect(e5)
end
function c24010609.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c24010609.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c24010609.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c24010609.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then
		Duel.SetChainLimit(c24010609.chainlm)
	end
end
function c24010609.chainlm(e,rp,tp)
	return tp==rp
end
function c24010609.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x115) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(24010609)
		if flag then
			c:SetFlagEffectLabel(24010609,flag+1)
		else
			c:RegisterFlagEffect(24010609,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	end
end
function c24010609.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x115) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(24010609)
		if flag and flag>0 then
			c:SetFlagEffectLabel(24010609,flag-1)
		end
	end
end
function c24010609.setfilter(c)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c24010609.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(24010609)
	if chk==0 then return ct and ct>0 and Duel.IsExistingMatchingCard(c24010609.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c24010609.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24010609.setfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=e:GetHandler():GetFlagEffectLabel(24010609) or 0
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tg=Group.CreateGroup()
	local tg1=Group.CreateGroup()
	local field=false
	local init=1
	if g:IsExists(Card.IsType,1,nil,TYPE_FIELD) then field=true end
	while ct>0 and (ft>0 or field) and g:GetCount()>0 do
		if ft==0 then g=g:Filter(Card.IsType,nil,TYPE_FIELD) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,init,1,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsType(TYPE_FIELD) then
				tg:Merge(sg)
				g:Remove(Card.IsType,nil,TYPE_FIELD)
				field=false
			else
				tg1:Merge(sg)
				g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
				ft=ft-1
			end
			init=0
			ct=ct-1
		else
			break
		end
	end
	tg:Merge(tg1)
	Duel.SSet(tp,tg)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end

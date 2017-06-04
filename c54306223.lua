--ヴェノム・スワンプ
function c54306223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54306223,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c54306223.acop)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(c54306223.atkval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(54306223,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+54306223)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c54306223.destg)
	e4:SetOperation(c54306223.desop)
	c:RegisterEffect(e4)
end
function c54306223.atkval(e,c)
	return c:GetCounter(0x1009)*-500
end
function c54306223.acop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Group.CreateGroup()
	local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=tg:GetFirst()
	while tc do
		if tc:IsCanAddCounter(0x1009,1) and not tc:IsSetCard(0x50) then
			local atk=tc:GetAttack()
			tc:AddCounter(0x1009,1)
			if atk>0 and tc:GetAttack()==0 then
				g:AddCard(tc)
			end
		end
		tc=tg:GetNext()
	end
	if g:GetCount()>0 then
		Duel.RaiseEvent(g,EVENT_CUSTOM+54306223,e,0,0,0,0)
	end
end
function c54306223.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c54306223.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

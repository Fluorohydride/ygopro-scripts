--呪詛返しのヒトガタ
function c33391067.initial_effect(c)
	--reflect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c33391067.condition)
	e1:SetOperation(c33391067.refop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33391067)
	e2:SetCondition(c33391067.setcon)
	e2:SetTarget(c33391067.settg)
	e2:SetOperation(c33391067.setop)
	c:RegisterEffect(e2)
end
function c33391067.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.damcon1(e,tp,eg,ep,ev,re,r,rp) and re:IsActiveType(TYPE_MONSTER)
end
function c33391067.refop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c33391067.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c33391067.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel()
end
function c33391067.setcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c33391067.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c33391067.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end

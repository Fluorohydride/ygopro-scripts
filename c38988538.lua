--ダイナミスト・プレシオス
function c38988538.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38988538,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c38988538.negcon)
	e1:SetOperation(c38988538.negop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c38988538.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c38988538.atkval)
	c:RegisterEffect(e3)
end
function c38988538.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd8) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c38988538.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return e:GetHandler():GetFlagEffect(38988538)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
		and g and g:IsExists(c38988538.tfilter,1,e:GetHandler(),tp) and Duel.IsChainDisablable(ev)
end
function c38988538.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(38988538,1)) then
		e:GetHandler():RegisterFlagEffect(38988538,RESET_EVENT+0x1fe0000,0,1)
		Duel.NegateEffect(ev)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c38988538.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd8)
end
function c38988538.atkval(e,c)
	return Duel.GetMatchingGroupCount(c38988538.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*-100
end

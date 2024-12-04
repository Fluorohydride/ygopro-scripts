--静冠の呪眼
function c79400597.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79400597+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c79400597.target)
	e1:SetOperation(c79400597.activate)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79400597.rmtg)
	e2:SetOperation(c79400597.rmop)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c79400597.tgcon)
	e3:SetTarget(c79400597.tgtg)
	e3:SetOperation(c79400597.tgop)
	c:RegisterEffect(e3)
end
function c79400597.costfilter(c)
	return c:IsSetCard(0x129) and c:IsAbleToRemoveAsCost()
end
function c79400597.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c79400597.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(79400597,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c79400597.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetLabel(0)
	end
end
function c79400597.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c79400597.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return d~=nil and d:IsAbleToRemove() and a:IsControler(tp) and a:IsSetCard(0x129)
		and a:GetEquipGroup() and a:GetEquipGroup():IsExists(Card.IsCode,1,nil,44133040) end
	e:SetLabelObject(d)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,d,1,0,0)
end
function c79400597.rmop(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if e:GetHandler():IsRelateToEffect(e) and d:IsRelateToBattle() then
		Duel.Remove(d,POS_FACEUP,REASON_EFFECT)
	end
end
function c79400597.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_SZONE)
end
function c79400597.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x129)
end
function c79400597.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c79400597.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79400597.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79400597,1))
	local g=Duel.SelectTarget(tp,c79400597.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c79400597.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end

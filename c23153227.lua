--七皇昇格
---@param c Card
function c23153227.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23153227,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23153227)
	e1:SetTarget(c23153227.target)
	e1:SetOperation(c23153227.operation)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23153227,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,23153228)
	e2:SetCondition(c23153227.cpcon)
	e2:SetCost(c23153227.cpcost)
	e2:SetTarget(c23153227.cptg)
	e2:SetOperation(c23153227.cpop)
	c:RegisterEffect(e2)
end
function c23153227.filter(c)
	return (not c:IsCode(23153227) and c:IsSetCard(0x175) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x176) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x95) and c:IsType(TYPE_QUICKPLAY))
end
function c23153227.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23153227.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c23153227.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c23153227.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and Duel.SelectOption(tp,1190,aux.Stringid(23153227,2))==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c23153227.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c23153227.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c23153227.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c23153227.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c23153227.cpfilter(c)
	return c:GetType()&TYPE_SPELL==TYPE_SPELL and c:IsSetCard(0x95) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c23153227.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c23153227.cpfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23153227.cpfilter,tp,LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c23153227.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

--HSRカイドレイク
function c5772618.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c5772618.sfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--link success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5772618,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,5772618)
	e1:SetCondition(c5772618.con)
	e1:SetTarget(c5772618.target)
	e1:SetOperation(c5772618.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5772618,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,5772619)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c5772618.thcon)
	e2:SetTarget(c5772618.thtg)
	e2:SetOperation(c5772618.thop)
	c:RegisterEffect(e2)
end
function c5772618.sfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c5772618.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c5772618.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c5772618.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local b2=Duel.GetMatchingGroup(c5772618.negfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #b1>0 or #b2>0 end
	local off=1
	local ops={}
	local opval={}
	if #b1>0 then
		ops[off]=aux.Stringid(5772618,1)
		opval[off]=0
		off=off+1
	end
	if #b2>0 then
		ops[off]=aux.Stringid(5772618,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(5772618,sel+1))
	if sel==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,b1,b1:GetCount(),0,0)
	else
		e:SetCategory(CATEGORY_DISABLE)
	end
end
function c5772618.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local b2=Duel.GetMatchingGroup(c5772618.negfilter,tp,0,LOCATION_ONFIELD,nil)
	if sel==0 then
		Duel.Destroy(b1,REASON_EFFECT)
	else
		local nc=b2:GetFirst()
		while nc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e2)
			if nc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				nc:RegisterEffect(e3)
			end
			nc=b2:GetNext()
		end
	end
end
function c5772618.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp
end
function c5772618.thfilter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c5772618.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5772618.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5772618.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5772618.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

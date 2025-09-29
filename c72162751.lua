--Queen of the Blazing Domain
local s,id,o=GetID()
function s.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.desfilter1(c,e)
	return c:IsCanBeEffectTarget(e)
end
function s.desfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.fselect(g,tp)
	return g:IsExists(s.desfilter2,1,nil) and Duel.GetMZoneCount(tp,g)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.desfilter1,tp,LOCATION_ONFIELD,0,nil,e)
	if chk==0 then return g:CheckSubGroup(s.fselect,1,2,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,s.fselect,false,1,2,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(aux.AND(Card.IsRelateToChain,Card.IsOnField),nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():GetCount()
		local c=e:GetHandler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
		if not c:IsRelateToChain() then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if ct==1 then
				c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetLabel(Duel.GetTurnCount()+1)
				e1:SetLabelObject(e:GetHandler())
				e1:SetCondition(s.thcon)
				e1:SetOperation(s.thop)
				Duel.RegisterEffect(e1,tp)
			else
				--remove
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(id,2))
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
				e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(LOCATION_REMOVED)
				e2:SetTarget(s.rmtg)
				c:RegisterEffect(e2)
			end
		end
	end
end
function s.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end

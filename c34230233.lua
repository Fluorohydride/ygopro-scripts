--暗黒界の龍神 グラファ
---@param c Card
function c34230233.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c34230233.spcon)
	e1:SetTarget(c34230233.sptg)
	e1:SetOperation(c34230233.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34230233,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c34230233.descon)
	e2:SetTarget(c34230233.destg)
	e2:SetOperation(c34230233.desop)
	c:RegisterEffect(e2)
end
function c34230233.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6) and not c:IsCode(34230233) and c:IsAbleToHandAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function c34230233.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c34230233.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c34230233.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c34230233.spfilter,tp,LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c34230233.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_SPSUMMON)
end
function c34230233.descon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and bit.band(r,0x4040)==0x4040
end
function c34230233.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if rp==1-tp and tp==e:GetLabel() then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(CATEGORY_DESTROY)
	end
end
function c34230233.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and rp==1-tp and tp==e:GetLabel() then
		Duel.BreakEffect()
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if hg:GetCount()>0 then
			local cg=hg:RandomSelect(tp,1)
			local cc=cg:GetFirst()
			Duel.ConfirmCards(tp,cc)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.SelectYesNo(tp,aux.Stringid(34230233,1)) then
				Duel.SpecialSummon(cc,0,tp,tp,false,false,POS_FACEUP)
			else Duel.ShuffleHand(1-tp) end
		end
	end
end

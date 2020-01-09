--宣告者の預言
function c27383110.initial_effect(c)
	aux.AddCodeList(c,44665365)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27383110.target)
	e1:SetOperation(c27383110.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(27383110,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+27383110)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c27383110.thcon)
	e2:SetCost(c27383110.thcost)
	e2:SetTarget(c27383110.thtg)
	e2:SetOperation(c27383110.thop)
	c:RegisterEffect(e2)
	--event
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c27383110.evcon)
	e3:SetOperation(c27383110.evop)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
end
function c27383110.filter(c,e,tp)
	return c:IsCode(44665365)
end
function c27383110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c27383110.filter,e,tp,mg,nil,Card.GetOriginalLevel,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c27383110.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c27383110.filter,e,tp,mg,nil,Card.GetOriginalLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetOriginalLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetOriginalLevel(),tp,tc,tc:GetOriginalLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		e:GetLabelObject():SetLabelObject(tc)
	end
end
function c27383110.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function c27383110.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c27383110.thfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c27383110.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	local mat=tc:GetMaterial()
	if chkc then return mat:IsContains(chkc) and c27383110.thfilter(chkc,e,tp) end
	if chk==0 then return mat:IsExists(c27383110.thfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=mat:FilterSelect(tp,c27383110.thfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c27383110.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c27383110.evcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject()~=nil
end
function c27383110.evop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.RaiseEvent(tc,EVENT_CUSTOM+27383110,e,0,tp,tp,0)
	e:SetLabelObject(nil)
end

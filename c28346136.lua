--銀河眼の極光波竜
function c28346136.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c28346136.ovfilter,aux.Stringid(28346136,0),2,c28346136.xyzop)
	c:EnableReviveLimit()
	--CANNOT be tg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28346136,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c28346136.cost)
	e1:SetOperation(c28346136.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28346136,2))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c28346136.con)
	e2:SetTarget(c28346136.tg)
	e2:SetOperation(c28346136.op)
	c:RegisterEffect(e2)
end
function c28346136.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10e5)
end
function c28346136.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,28346136)==0 end
	Duel.RegisterFlagEffect(tp,28346136,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c28346136.filter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c28346136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c28346136.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c28346136.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e3:SetValue(aux.tgoval)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c28346136.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c28346136.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsRankBelow(9) and c:IsRace(RACE_DRAGON) and c:IsAbleToExtra()
end
function c28346136.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28346136.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function c28346136.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c28346136.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local c=e:GetHandler()
	local sc=g:GetFirst()
	if sc:IsLocation(LOCATION_EXTRA) and c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp)
		and c:IsCanBeXyzMaterial(sc) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.SelectYesNo(tp,aux.Stringid(28346136,4)) then
		Duel.BreakEffect()
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

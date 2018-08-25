--V－LAN ヒドラ
function c13536606.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c13536606.matfilter,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c13536606.atkval)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13536606,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,13536606)
	e2:SetTarget(c13536606.tktg)
	e2:SetOperation(c13536606.tkop)
	c:RegisterEffect(e2)
end
function c13536606.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN)
end
function c13536606.atkval(e,c)
	return c:GetMutualLinkedGroupCount()*300
end
function c13536606.rfilter(c,tp,g)
	local ft=Duel.GetMZoneCount(tp,c)
	local lk=math.min(3,ft)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsLinkBelow(lk) and c:IsReleasableByEffect() and g:IsContains(c)
		and (ft==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
end
function c13536606.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetMutualLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13536606.rfilter(chkc,tp,lg) end
	if chk==0 then return Duel.IsExistingTarget(c13536606.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lg)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13536607,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectTarget(tp,c13536606.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lg)
	local ct=rg:GetFirst():GetLink()
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c13536606.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetLink()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<ct or (ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,13536607,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
		for i=1,ct do
			local token=Duel.CreateToken(tp,13536607)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabel(ct)
	e1:SetTarget(c13536606.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c13536606.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLink(e:GetLabel())
end

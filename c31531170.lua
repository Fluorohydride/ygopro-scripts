--共鳴する振動
function c31531170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c31531170.target)
	e1:SetOperation(c31531170.activate)
	c:RegisterEffect(e1)
end
function c31531170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_PZONE,2,nil) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_PZONE)
	Duel.SetTargetCard(g)
end
function c31531170.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c31531170.pendcon)
	e1:SetOperation(c31531170.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(31531170,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc2:GetFieldID())
	tc2:RegisterFlagEffect(31531170,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc1:GetFieldID())
end
function c31531170.pendcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(31531170) then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return false end
	if og then
		return og:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(aux.PConditionFilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c31531170.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_CARD,0,31531170)
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,aux.PConditionFilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.PConditionFilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end

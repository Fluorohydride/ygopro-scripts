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
	if not PENDULUM_CHECKLIST then PENDULUM_CHECKLIST=0 end
	if chk==0 then return (PENDULUM_CHECKLIST&(0x1<<tp)==0 or Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)) and Duel.IsExistingTarget(nil,tp,0,LOCATION_PZONE,2,nil) end
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
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if PENDULUM_CHECKLIST&(0x1<<tp)~=0 and #eset==0 then return false end
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(31531170) then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return false end
	if og then
		return og:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
	else
		return Duel.IsExistingMatchingCard(aux.PConditionFilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale,eset)
	end
end
function c31531170.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp=e:GetOwnerPlayer()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,LOCATION_EXTRA):Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,LOCATION_EXTRA,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=PENDULUM_CHECKLIST&(0x1<<tp)==0
	local b2=#eset>0
	if b1 and b2 then
		local options={1163}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		if op>0 then
			ce=eset[op]
		end
	elseif b2 and not b1 then
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		ce=eset[op+1]
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:FilterSelect(tp,aux.PConditionExtraFilterSpecific,0,ft,nil,e,tp,lscale,rscale,ce)
	if #g==0 then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:Reset()
	else
		PENDULUM_CHECKLIST=PENDULUM_CHECKLIST|(0x1<<tp)
	end
	Duel.Hint(HINT_CARD,0,31531170)
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end

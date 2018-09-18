--鏡像のスワンプマン
function c50277973.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c50277973.target)
	e1:SetOperation(c50277973.activate)
	c:RegisterEffect(e1)
end
function c50277973.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rac=0
		local crac=1
		while bit.band(RACE_ALL,crac)~=0 do
			local catt=1
			for iatt=0,7 do
				if Duel.IsPlayerCanSpecialSummonMonster(tp,50277973,0,0x11,1800,1000,4,crac,catt) then
					rac=rac+crac
					break
				end
				catt=catt*2
			end
			crac=crac*2
		end
		e:SetLabel(rac)
		return rac~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local crac=Duel.AnnounceRace(tp,1,e:GetLabel())
	local att=0
	local catt=1
	for iatt=0,7 do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,50277973,0,0x11,1800,1000,4,crac,catt) then
			att=att+catt
		end
		catt=catt*2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	catt=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(crac)
	Duel.SetTargetParam(catt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50277973.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rac=e:GetLabel()
	local att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,50277973,0,0x11,1800,1000,4,rac,att) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,att,rac,0,0,0)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
